# Akiles

**TODO: Add description**

## Installation

The package can be installed by adding `akiles` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [ 
    # ...
    {:akiles, git: "git@github.com:muppy-life/akiles.git", tag: "v2"},
    # ...
  ]
end
```

To configurate akiles you need to include the following code to `config.exs`:

```elixir
config :akiles,
  api_key: System.get_env("AKILES_API_KEY", nil) || raise "Missing env variable AKILES_API_KEY"
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/akiles>.

