defmodule Akiles.MixProject do
  use Mix.Project

  def project do
    [
      app: :akiles,
      version: "0.1.0",
      elixir: "~> 1.18.1",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:jason, "~> 1.0"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/test_helper.exs"]
  defp elixirc_paths(_), do: ["lib"]
end
