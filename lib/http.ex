defmodule Akiles.Http do

  alias HTTPoison.Response

  def get(endpoint) do
    with {:ok, %Response{body: res}} <- HTTPoison.get(base_url() <> endpoint, headers()),
      {:ok, res} <- Jason.decode(res) do
        case res do
          %{"args" => _, "message" => msg, "type" => type} -> {:error, "#{type |> String.upcase()} - #{msg}"}
          res -> {:ok, res}
        end
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def get(endpoint, params) do
    params
    |> Enum.reduce("", &merge_args(&1, &2))
    |> String.slice(1..-1)
    |> then(&(endpoint <> "?" <> &1))
    |> get()
  end

  @spec list(String.t(), [{atom(), String.t()}] | nil, String.t() | nil) :: {:ok, [Map.t()]} | {:ok, []} | {:error, String.t()}
  def list(endpoint, filter_val \\ nil, cursor \\ nil) do
    case list_inner(endpoint, filter_val, cursor) do
      {:error, msg} -> {:error, msg}
      data -> {:ok, data}
    end
  end
 
  :cursor_next
  :has_next

  defp list_inner(endpoint, filter_val, cursor) do
    params = case {filter_val, cursor} do
      {nil, nil} -> []
      {[{field, val}], nil} -> [{field, val}]
      {nil, cursor} -> [cursor: cursor]
      {[{field, val}], cursor} -> [{field, val}, cursor: cursor]
    end

    case get(endpoint, params) do
      {:ok, %{"has_next" => true, "cursor_next" => cursor_next, "data" => data}} -> data ++ list_inner(endpoint, filter_val, cursor_next)
      {:ok, %{"has_next" => false, "data" => data}} -> data
      {:error, msg} -> {:error, msg}
    end
  end

  def patch(endpoint, data) do
    with {:ok, data} <- Jason.encode(data),
      {:ok, %Response{body: res}} <- HTTPoison.patch(base_url() <> endpoint, data, headers()),
      {:ok, res} <- Jason.decode(res) do
        case res do
          %{"args" => _, "message" => msg, "type" => type} -> {:error, "#{type |> String.upcase()} - #{msg}"}
          res -> {:ok, res}
        end
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def post(endpoint, data) do
    with {:ok, data} <- Jason.encode(data),
      {:ok, %Response{body: res}} <- HTTPoison.post(base_url() <> endpoint, data, headers()),
      {:ok, res} <- Jason.decode(res) do
        case res do
          %{"args" => _, "message" => msg, "type" => type} -> {:error, "#{type |> String.upcase()} - #{msg}"}
          res -> {:ok, res}
        end
    else
      {:error, msg} -> {:error, msg}
    end
  end

  def delete(endpoint) do
    with {:ok, %Response{body: res}} <- HTTPoison.delete(base_url() <> endpoint, headers()),
      {:ok, res} <- Jason.decode(res) do
        case res do
          %{"args" => _, "message" => msg, "type" => type} -> {:error, "#{type |> String.upcase()} - #{msg}"}
          res -> {:ok, res}
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

  defp base_url, do: "https://api.akiles.app/v2"

  defp merge_args({_arg, nil}, _acc) do
    ""  
  end

  defp merge_args({arg, val}, acc) do
    "#{acc}&#{arg}=#{val}"
  end
end
