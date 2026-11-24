# Akiles

Elixir SDK for Akiles API.

## Installation

The package can be installed by adding `akiles` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [ 
    # ...
    {:akiles, git: "git@github.com:muppy-life/akiles.git", tag: "v2.5.0"},
    # ...
  ]
end
```

## Authentication

Akiles retires legacy API keys on **10 February 2027**; after that only OAuth
applications can call the API. The host application owns the OAuth connection
(authorization, storing and refreshing tokens) and plugs it in through a module
implementing `Akiles.TokenProvider`:

```elixir
config :akiles, token_provider: MyApp.AkilesOAuth
```

- `access_token/0` returns `{:ok, token}`; refresh it before it expires (one hour)
  and reuse it until then. `{:error, reason}` fails the call with `UNAUTHENTICATED`.
- On a `401` the SDK calls `invalidate/1` with the rejected token and retries once.

Without a provider the SDK sends the legacy key:

```elixir
config :akiles, api_key: System.get_env("AKILES_API_KEY")
```

## Other options

- `:timeout` / `:recv_timeout` (ms, defaults 60_000 / 120_000).
- `:max_retry_wait` (seconds, default 10): a `429` whose `Retry-After` is within
  this wait is retried once; longer waits return `{:error, "RATE_LIMITED - ..."}`.
- `:base_url` (default `https://api.akiles.app/v2`).

## Tests

`test/akiles/http_auth_test.exs` runs offline against Bypass. The other suites
call the real Akiles API with `AKILES_API_KEY` and create objects in that
organization: never run them against a production organization.

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/akiles>.

