use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :clinc_elixir, ClincElixirWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :clinc_elixir, ClincElixir.Repo,
  username: "postgres",
  password: "postgres",
  database: "clinc_elixir_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
