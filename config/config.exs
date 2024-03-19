import Config

config :akiles,
  api_key: System.get_env("AKILES_API_KEY", nil) || raise("Missing env variable AKILES_API_KEY")

# import_config "#{config_env()}.exs"
