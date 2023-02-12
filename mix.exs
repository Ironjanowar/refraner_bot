defmodule RefranerBot.MixProject do
  use Mix.Project

  def project do
    [
      app: :refraner_bot,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {RefranerBot.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.9"},
      {:ecto_sqlite3, "~> 0.9.1"},
      {:ex_gram, "~> 0.33"},
      {:tesla, "~> 1.4"},
      {:hackney, "~> 1.17"},
      {:jason, "~> 1.2"},
      {:logger_file_backend, "0.0.11"}
    ]
  end
end
