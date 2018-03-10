# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :othello_hall,
  namespace: OthelloHall,
  ecto_repos: [OthelloHall.Repo]

# Configures the endpoint
config :othello_hall, OthelloHallWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "cVPN5FX0haJyCAUjSBg5YMkhKBMzqHC6FtP3+s0hHdFuE4gbeLvQ0uaTStJfkQk0",
  render_errors: [view: OthelloHallWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: OthelloHall.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
