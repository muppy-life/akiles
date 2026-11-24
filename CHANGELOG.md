# Changelog

## v2.5.0

Akiles retires legacy API keys on 10 February 2027; after that only OAuth
applications can call the API.

- `Akiles.TokenProvider` behaviour and `config :akiles, token_provider: Module`:
  the SDK asks the provider for the bearer token. Without a provider it still
  sends `:api_key` (backwards compatible).
- `401`: the provider invalidates the rejected token and the request is retried once.
- `429`: retried once when `Retry-After` fits `:max_retry_wait` (default 10 s);
  longer waits return `{:error, "RATE_LIMITED - ..."}`.
- Transport and decode errors return `{:error, "HTTP_ERROR - ..."}` /
  `{:error, "INVALID_RESPONSE - ..."}` instead of raising in `Utils.manage_error/2`.
- An error on a later page of `Http.list/3` is returned instead of an improper list.
- Configurable `:base_url`; `AKILES_API_KEY` is no longer required by `config/config.exs`.
- Unknown fields in Akiles responses are ignored instead of raising: resources
  are built with `struct/2` instead of `struct!/2`. Akiles keeps adding fields
  (`tag_ids` on members and groups in April 2026, on gadgets in November 2026)
  and each one crashed every call returning that object. `Akiles.Gadget` gets
  `tag_ids`.
