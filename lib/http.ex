defmodule Akiles.Http do
  alias HTTPoison.Response

  @doc """
  Performs an HTTP 'GET' action.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Http.get("/members/")
      {:ok, %{
              "data" => [
                %{
                  "created_at" => "2023-03-10T18:35:09.870686208Z",
                  "ends_at" => nil,
                  ...
                }
              "has_next" => false
            }
  """
  @spec get(term()) :: {:ok, map()} | {:ok, list()} | {:error, term()}
  def get(endpoint) do
    with {:ok, %Response{body: res}} <-
           HTTPoison.get(base_url() <> endpoint, headers(), timeout()),
         {:ok, res} <- Jason.decode(res) do
      case res do
        %{"args" => _, "message" => msg, "type" => type} ->
          {:error, "#{type |> String.upcase()} - #{msg}"}

        res ->
          {:ok, res}
      end
    else
      {:error, msg} -> {:error, msg}
    end
  end

  @doc """
  Performs an HTTP 'GET' action and returns the data according to params.
  The method formats the endpoint to include the params in the form "?param1=val1"

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Http.get("/members/", %{name: "Nacho"})
      {:ok, %{
              "created_at" => "2023-03-10T18:35:09.870686208Z",
              "ends_at" => nil,
              ...
              "name" => "Nacho"
              ...
            }
  """
  @spec get(term(), term()) :: {:ok, map()} | {:error, term()}
  def get(endpoint, params) do
    params
    |> Enum.reduce("", &merge_args(&1, &2))
    |> String.slice(1..-1//1)
    |> then(&(endpoint <> "?" <> &1))
    |> get()
  end

  @doc """
  Returns all the data from the get request. Iterates over all the API pages to
  return all the data. Optionally it accepts filter values. Also optionally accepts
  a cursor value.

  Returns `{:ok, data}`.

  ## Examples

      iex> Akiles.Http.list("/members/", %{name: "Nacho"})
      {:ok, [
              %{
                "created_at" => "2023-03-10T18:35:09.870686208Z",
                "ends_at" => nil,
                ...
                "name" => "Nacho"
                ...
              },
              %{
                ...
              }]}
  """
  @spec list(term(), [{atom(), term()}] | nil, term() | nil) ::
          {:ok, [map()]} | {:ok, []} | {:error, term()}
  def list(endpoint, filter_val \\ nil, cursor \\ nil) do
    case list_inner(endpoint, filter_val, cursor) do
      {:error, msg} -> {:error, msg}
      data -> {:ok, data}
    end
  end

  :cursor_next
  :has_next

  @doc """
  Performs all the iteration over the API pages for the list/3 method.
  Takes a route, *filter_value, *cursor and returns the data

  Returns `data`.

  ## Examples

      iex> Akiles.Http.list_inner("/members/", %{name: "Nacho"})
      [
        %{
          "created_at" => "2023-03-10T18:35:09.870686208Z",
          "ends_at" => nil,
          ...
          "name" => "Nacho"
          ...
        },
        %{
          ...
        }]
  """
  @spec list_inner(term(), [{term(), term()}] | nil, term() | nil) ::
          list() | map() | {:error, term()}
  def list_inner(endpoint, filter_val, cursor) do
    params =
      case {filter_val, cursor} do
        {nil, nil} -> []
        {[{field, val}], nil} -> [{field, val}]
        {nil, cursor} -> [cursor: cursor]
        {[{field, val}], cursor} -> [{field, val}, cursor: cursor]
      end

    case get(endpoint, params) do
      {:ok, %{"has_next" => true, "cursor_next" => cursor_next, "data" => data}} ->
        data ++ list_inner(endpoint, filter_val, cursor_next)

      {:ok, %{"has_next" => false, "data" => data}} ->
        data

      {:error, msg} ->
        {:error, msg}
    end
  end

  @doc """
  This function filters item by getting lists of items until one matches the specifed criteria.
  """
  @spec search(term(), [{term(), term()}], term() | nil) :: {:ok, map()} | {:error, term()}
  def search(endpoint, [{key, val}] = _param, cursor) when key |> is_atom() do
    search(endpoint, [{key |> Atom.to_string(), val}], cursor)
  end

  def search(endpoint, param, nil) do
    res = get(endpoint)

    manage_search(endpoint, res, param)
    |> then(&{:ok, &1})
  end

  def search(endpoint, param, cursor) do
    res = get(endpoint, cursor: cursor)

    manage_search(endpoint, res, param)
    |> then(&{:ok, &1})
  end

  defp manage_search(
         endpoint,
         {:ok, %{"has_next" => true, "cursor_next" => cursor, "data" => data}},
         [{key, val}] = param
       ) do
    res = data |> Enum.find(fn x -> Map.get(x, key) == val end)

    case res do
      nil -> search(endpoint, param, cursor)
      res -> res
    end
  end

  defp manage_search(_endpoint, {:ok, %{"has_next" => false, "data" => data}}, [{key, val}]) do
    data |> Enum.find(fn x -> Map.get(x, key) == val end)
  end

  defp manage_search(_endpoint, {:error, msg}, _param), do: {:error, msg}

  @doc """
  Performs an HTTP PATCH action to the 'endpoint' path, passing the data encoded

  Returns the patched object.

  ## Examples

      iex> Akiles.Http.patch("/members/mem_3x8ndhg6q5dhhcehj7a1", %{metadata: %{test_key: "Test"}})
      {:ok, %{
            "created_at" => "2023-03-24T11:07:07.059453952Z",
            "ends_at" => nil,
            "id" => "mem_3x8ndhg6q5dhhcehj7a1",
            "is_deleted" => false,
            "metadata" => %{"test_key" => "Test"},
            "name" => "Nacho",
            "organization_id" => "org_3x5bggk73t6d37ubd7vh",
            "starts_at" => nil
            }}
  """
  @spec patch(term(), map()) :: {:ok, map()} | {:error, term()}
  def patch(endpoint, data) do
    with {:ok, data} <- Jason.encode(data),
         {:ok, %Response{body: res}} <-
           HTTPoison.patch(base_url() <> endpoint, data, headers(), timeout()),
         {:ok, res} <- Jason.decode(res) do
      case res do
        %{"args" => _, "message" => msg, "type" => type} ->
          {:error, "#{type |> String.upcase()} - #{msg}"}

        res ->
          {:ok, res}
      end
    else
      {:error, msg} -> {:error, msg}
    end
  end

  @doc """
  Performs an HTTP POST action

  Returns the posted object.

  ## Examples

      iex> Akiles.Http.post("/members/", %{name: "John Doe"})
      {:ok, %{
            "created_at" => "2023-03-24T11:07:07.059453952Z",
            "ends_at" => nil,
            "id" => "mem_3x8ndhg6q5dhhcehj7a1",
            "is_deleted" => false,
            "metadata" => %{},
            "name" => "John Doe",
            "organization_id" => "org_3x5bggk73t6d37ubd7vh",
            "starts_at" => nil
            }}
  """
  @spec post(term(), map()) :: {:ok, map()} | {:error, term()}
  def post(endpoint, data) do
    with {:ok, data} <- Jason.encode(data),
         {:ok, %Response{body: res}} <-
           HTTPoison.post(base_url() <> endpoint, data, headers(), timeout()),
         {:ok, res} <- Jason.decode(res) do
      case res do
        %{"args" => _, "message" => msg, "type" => type} ->
          {:error, "#{type |> String.upcase()} - #{msg}"}

        res ->
          {:ok, res}
      end
    else
      {:error, msg} -> {:error, msg}
    end
  end

  @doc """
  Performs an HTTP DELETE action

  Returns the deleted object.

  ## Examples

      iex> Akiles.Http.delete("/members/mem_3x8ndhg6q5dhhcehj7a1")
      {:ok, %{
            "created_at" => "2023-03-24T11:07:07.059453952Z",
            "ends_at" => nil,
            "id" => "mem_3x8ndhg6q5dhhcehj7a1",
            "is_deleted" => true,
            "metadata" => %{},
            "name" => "John Doe",
            "organization_id" => "org_3x5bggk73t6d37ubd7vh",
            "starts_at" => nil
            }}
  """
  @spec delete(term()) :: {:ok, map()} | {:error, term()}
  def delete(endpoint) do
    with {:ok, %Response{body: res}} <-
           HTTPoison.delete(base_url() <> endpoint, headers(), timeout()),
         {:ok, res} <- Jason.decode(res) do
      case res do
        %{"args" => _, "message" => msg, "type" => type} ->
          {:error, "#{type |> String.upcase()} - #{msg}"}

        res ->
          {:ok, res}
      end
    else
      {:error, msg} -> {:error, msg}
    end
  end

  defp headers do
    [
      {"Authorization", "Bearer " <> Application.fetch_env!(:akiles, :api_key)},
      {"Content-type", "application/json"}
    ]
  end

  defp timeout do
    [
      timeout: Application.get_env(:akiles, :timeout, 60_000),
      recv_timeout: Application.get_env(:akiles, :recv_timeout, 120_000)
    ]
  end

  defp base_url, do: "https://api.akiles.app/v2"

  defp merge_args({_arg, nil}, _acc), do: ""
  defp merge_args({arg, val}, acc), do: "#{acc}&#{arg}=#{val}"
end
