defmodule Dnsierge.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Dnsierge.Repo,
      # Start the Telemetry supervisor
      DnsiergeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Dnsierge.PubSub},
      # Start the Endpoint (http/https)
      DnsiergeWeb.Endpoint,
      # Start a worker by calling: Dnsierge.Worker.start_link(arg)
      # {Dnsierge.Worker, arg}
      Nameservers
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dnsierge.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DnsiergeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
