defmodule Akiles.TokenProvider do
  @moduledoc """
  Supplies the bearer token for every Akiles API call.

  Akiles retires legacy API keys on 10 February 2027; from then on only OAuth
  applications can call the API, with access tokens that expire after one hour.
  The host application owns the OAuth connection (storing and refreshing the
  tokens) and plugs it into the SDK with:

      config :akiles, token_provider: MyApp.AkilesOAuth

  Without a provider the SDK keeps sending the static `:api_key`.
  """

  @doc """
  Returns a valid access token, refreshing it first if it is about to expire.
  An `{:error, reason}` makes the API call fail with `UNAUTHENTICATED`.
  """
  @callback access_token() :: {:ok, String.t()} | {:error, term()}

  @doc """
  Called when the API rejects `token` with a 401, so the provider drops it and
  the next `access_token/0` returns a fresh one. The SDK retries the request once.
  """
  @callback invalidate(token :: String.t()) :: :ok
end
