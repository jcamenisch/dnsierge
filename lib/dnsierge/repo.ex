defmodule Dnsierge.Repo do
  use Ecto.Repo,
    otp_app: :dnsierge,
    adapter: Ecto.Adapters.Postgres
end
