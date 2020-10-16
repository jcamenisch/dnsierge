defmodule DnsiergeWeb.PageController do
  use DnsiergeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
