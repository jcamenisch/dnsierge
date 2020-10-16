# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :dnsierge,
  ecto_repos: [Dnsierge.Repo]

# Configures the endpoint
config :dnsierge, DnsiergeWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "r19tjhtkrmsCM3LkNXTcTOUMtJnt7qjc7psPszRJ6iCvQb9aAE32lOo4ibMvc8qx",
  render_errors: [view: DnsiergeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Dnsierge.PubSub,
  live_view: [signing_salt: "uC1EA8wf"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
