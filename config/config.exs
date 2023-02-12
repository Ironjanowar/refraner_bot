import Config

config :refraner_bot, RefranerBot.Repo,
  adapter: Ecto.Adapters.SQLite3,
  database: "refraner.db"

config :refraner_bot, ecto_repos: [RefranerBot.Repo]

config :logger,
  level: :debug,
  truncate: :infinity,
  backends: [{LoggerFileBackend, :debug}, {LoggerFileBackend, :error}]

config :logger, :debug,
  path: "log/debug.log",
  level: :debug,
  format: "$dateT$timeZ [$level] $message\n"

config :logger, :error,
  path: "log/error.log",
  level: :error,
  format: "$dateT$timeZ [$level] $message\n"

config :ex_gram,
  token: {:system, "BOT_TOKEN"}
