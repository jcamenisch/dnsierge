defmodule DnsiergeWeb.DomainController do
  use DnsiergeWeb, :controller

  def index(conn, params) do
    conn
    |> assign(:domain, params["domain"])
    |> assign(:nameservers, Nameservers.get(params["domain"]))
    |> render("index.html")
  end
end
