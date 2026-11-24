defmodule Akiles.Auth do
  @moduledoc """
  Resolves the bearer token for API calls: the configured
  `Akiles.TokenProvider` (OAuth) when there is one, the legacy `:api_key`
  otherwise.
  """

  @doc "The token to send in the `Authorization` header."
  @spec token() :: {:ok, String.t()} | {:error, String.t()}
  def token do
    case provider() do
      nil -> api_key()
      provider -> provider_token(provider)
    end
  end

  @doc "Tells the provider that the API rejected `token`. No-op for the API key."
  @spec invalidate(String.t()) :: :ok
  def invalidate(token) do
    case provider() do
      nil -> :ok
      provider -> provider.invalidate(token)
    end
  end

  @doc "Whether a rejected token can be replaced by asking again (only with a provider)."
  @spec refreshable?() :: boolean()
  def refreshable?, do: provider() != nil

  defp provider, do: Application.get_env(:akiles, :token_provider)

  defp provider_token(provider) do
    case provider.access_token() do
      {:ok, token} when is_binary(token) and token != "" -> {:ok, token}
      {:error, reason} -> {:error, "UNAUTHENTICATED - #{format_reason(reason)}"}
      other -> {:error, "UNAUTHENTICATED - Unexpected token provider result #{inspect(other)}"}
    end
  end

  defp api_key do
    case Application.get_env(:akiles, :api_key) do
      key when is_binary(key) and key != "" -> {:ok, key}
      _ -> {:error, "UNAUTHENTICATED - No Akiles token provider or API key configured"}
    end
  end

  defp format_reason(reason) when is_binary(reason), do: reason
  defp format_reason(reason), do: inspect(reason)
end
