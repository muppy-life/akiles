import Config

# Only for running this library's own tests. Host applications configure
# either a `:token_provider` (OAuth) or the legacy `:api_key`; see the README.
config :akiles, api_key: System.get_env("AKILES_API_KEY")

# import_config "#{config_env()}.exs"
