# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :clinc_elixir,
  ecto_repos: [ClincElixir.Repo]

# Configures the endpoint
config :clinc_elixir, ClincElixirWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "fq40TrGQZZPP1s9kXE8e5RTI26l2SUP/vEwlPKLZlLgkBEKmOxZ3RhqeS2SfFqaK",
  render_errors: [view: ClincElixirWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: ClincElixir.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
