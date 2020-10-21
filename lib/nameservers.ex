defmodule Nameservers do
  use Agent

  @root_servers Enum.map(?a..?m, fn c -> "#{<<c::utf8>>}.root-servers.net" end)

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def from_dig(domain, server) do
    run_cmd(["dig", "@#{server}", "ns", Regex.replace(~r/\\.*$/, domain, ".")])
    |> String.split("\n")
    |> Stream.map(&Regex.named_captures(~r/NS\t(?<host>\S+)/, &1)["host"])
    |> Enum.filter(& &1)
  end

  def run_cmd(cmd) do
    IO.puts(Enum.join(cmd, " "))
    {resp, 0} = System.cmd(hd(cmd), tl(cmd))
    resp
  end

  def get_for_segments([""]) do
    @root_servers
  end

  def get_for_segments([]) do
    @root_servers
  end

  def get_for_segments(segments) do
    cached_value = Agent.get(__MODULE__, &Map.get(&1, segments))

    if cached_value do
      cached_value
    else
      server = Enum.random(get_for_segments(tl(segments)))
      result = from_dig(Enum.join(segments, "."), server)

      Agent.update(__MODULE__, &(Map.put(&1, segments, result)))

      result
    end
  end

  def get(nil) do
    []
  end

  def get(fqdn) do
    fqdn |> String.split(".") |> get_for_segments()
  end
end
