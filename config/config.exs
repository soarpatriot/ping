# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ping,
  ecto_repos: [Ping.Repo]

# Configures the endpoint
config :ping, Ping.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "wDy5cWRKK97ToPx0WJ108Vo3Q4MwqOhbm0cQ3x2MxO7431Ir7t52zqQqzAcwnjuh",
  render_errors: [view: Ping.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ping.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
