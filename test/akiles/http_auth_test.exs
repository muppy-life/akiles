defmodule AkilesTest.FakeTokenProvider do
  @behaviour Akiles.TokenProvider
  use Agent

  def start_link(tokens),
    do: Agent.start_link(fn -> %{tokens: tokens, invalidated: []} end, name: __MODULE__)

  @impl true
  def access_token do
    Agent.get(__MODULE__, fn
      %{tokens: [token | _]} -> {:ok, token}
      %{tokens: []} -> {:error, :not_connected}
    end)
  end

  @impl true
  def invalidate(token) do
    Agent.update(__MODULE__, fn state ->
      %{
        state
        | tokens: List.delete(state.tokens, token),
          invalidated: [token | state.invalidated]
      }
    end)
  end

  def invalidated, do: Agent.get(__MODULE__, & &1.invalidated)
end

defmodule AkilesTest.HttpAuth do
  # Offline tests (Bypass): auth, 401/429 retries and error shapes. Unlike the
  # other suites they never reach the real Akiles API.
  use ExUnit.Case, async: false

  alias Akiles.Http
  alias AkilesTest.FakeTokenProvider

  setup do
    bypass = Bypass.open()
    previous = Application.get_all_env(:akiles)

    Application.put_env(:akiles, :base_url, "http://localhost:#{bypass.port}/v2")
    Application.put_env(:akiles, :api_key, "legacy-key")
    Application.delete_env(:akiles, :token_provider)

    on_exit(fn ->
      for {key, _} <- Application.get_all_env(:akiles), do: Application.delete_env(:akiles, key)
      for {key, value} <- previous, do: Application.put_env(:akiles, key, value)
    end)

    {:ok, bypass: bypass}
  end

  defp use_provider(tokens) do
    start_supervised!({FakeTokenProvider, tokens})
    Application.put_env(:akiles, :token_provider, FakeTokenProvider)
  end

  defp json(conn, status, body, headers \\ []) do
    conn =
      Enum.reduce(headers, conn, fn {name, value}, conn ->
        Plug.Conn.put_resp_header(conn, name, value)
      end)

    conn
    |> Plug.Conn.put_resp_content_type("application/json")
    |> Plug.Conn.resp(status, Jason.encode!(body))
  end

  defp bearer(conn), do: conn |> Plug.Conn.get_req_header("authorization") |> List.first()

  test "without a provider it sends the legacy API key", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/v2/organization", fn conn ->
      assert bearer(conn) == "Bearer legacy-key"
      json(conn, 200, %{"id" => "org_1"})
    end)

    assert {:ok, %{"id" => "org_1"}} = Http.get("/organization")
  end

  test "with a provider it sends the provider's access token", %{bypass: bypass} do
    use_provider(["oauth-1"])

    Bypass.expect_once(bypass, "POST", "/v2/members", fn conn ->
      assert bearer(conn) == "Bearer oauth-1"
      json(conn, 200, %{"id" => "mem_1"})
    end)

    assert {:ok, %{"id" => "mem_1"}} = Http.post("/members", %{name: "Jane"})
  end

  test "a 401 invalidates the token and retries once with a fresh one", %{bypass: bypass} do
    use_provider(["expired", "fresh"])
    {:ok, calls} = Agent.start_link(fn -> [] end)

    Bypass.expect(bypass, "GET", "/v2/members/mem_1", fn conn ->
      Agent.update(calls, &[bearer(conn) | &1])

      case bearer(conn) do
        "Bearer expired" -> Plug.Conn.resp(conn, 401, "")
        "Bearer fresh" -> json(conn, 200, %{"id" => "mem_1"})
      end
    end)

    assert {:ok, %{"id" => "mem_1"}} = Http.get("/members/mem_1")
    assert FakeTokenProvider.invalidated() == ["expired"]
    assert Agent.get(calls, &Enum.reverse/1) == ["Bearer expired", "Bearer fresh"]
  end

  test "a second 401 gives up", %{bypass: bypass} do
    use_provider(["expired", "also-rejected"])

    Bypass.expect(bypass, "GET", "/v2/members/mem_1", fn conn -> Plug.Conn.resp(conn, 401, "") end)

    assert {:error, "UNAUTHORIZED - " <> _} = Http.get("/members/mem_1")
    assert FakeTokenProvider.invalidated() == ["expired"]
  end

  test "a 401 with the legacy API key is not retried", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/v2/organization", fn conn ->
      Plug.Conn.resp(conn, 401, "")
    end)

    assert {:error, "UNAUTHORIZED - " <> _} = Http.get("/organization")
  end

  test "a provider without a connection fails before calling Akiles" do
    use_provider([])

    assert {:error, "UNAUTHENTICATED - :not_connected"} = Http.get("/organization")
  end

  test "a 429 within max_retry_wait is retried after Retry-After", %{bypass: bypass} do
    {:ok, attempts} = Agent.start_link(fn -> 0 end)

    Bypass.expect(bypass, "GET", "/v2/organization", fn conn ->
      case Agent.get_and_update(attempts, &{&1, &1 + 1}) do
        0 ->
          json(
            conn,
            429,
            %{
              "type" => "rate_limited",
              "message" => "Too many attempts",
              "args" => %{"retry_after" => 0}
            },
            [
              {"retry-after", "0"}
            ]
          )

        _ ->
          json(conn, 200, %{"id" => "org_1"})
      end
    end)

    assert {:ok, %{"id" => "org_1"}} = Http.get("/organization")
    assert Agent.get(attempts, & &1) == 2
  end

  test "a 429 asking to wait longer than max_retry_wait is returned", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/v2/organization", fn conn ->
      json(
        conn,
        429,
        %{
          "type" => "rate_limited",
          "message" => "Too many attempts",
          "args" => %{"retry_after" => 600}
        },
        [
          {"retry-after", "600"}
        ]
      )
    end)

    assert {:error, "RATE_LIMITED - Too many requests, retry after 600s"} =
             Http.get("/organization")
  end

  test "API errors keep the TYPE - message shape", %{bypass: bypass} do
    Bypass.expect_once(bypass, "GET", "/v2/members/missing", fn conn ->
      json(conn, 404, %{
        "type" => "object_not_found",
        "message" => "Object missing not found",
        "args" => %{}
      })
    end)

    assert {:error, "OBJECT_NOT_FOUND - Object missing not found"} = Http.get("/members/missing")
  end

  test "an error on a later page is returned instead of a partial list", %{bypass: bypass} do
    Bypass.expect(bypass, "GET", "/v2/members", fn conn ->
      case Plug.Conn.fetch_query_params(conn).query_params do
        %{"cursor" => "page2"} ->
          json(
            conn,
            429,
            %{"type" => "rate_limited", "message" => "Too many attempts", "args" => %{}},
            [
              {"retry-after", "600"}
            ]
          )

        _ ->
          json(conn, 200, %{
            "data" => [%{"id" => "mem_1"}],
            "has_next" => true,
            "cursor_next" => "page2"
          })
      end
    end)

    assert {:error, "RATE_LIMITED - " <> _} = Http.list("/members")
  end

  test "transport errors come back as {:error, _} through the resource modules", %{bypass: bypass} do
    Bypass.down(bypass)

    assert {:error, "[Elixir.Akiles.Member] HTTP_ERROR - " <> _} =
             Akiles.Member.get_member("mem_1")
  end
end
