defmodule Nameservers do
  use Agent

  @root_servers Enum.map(?a..?m, fn c -> "#{<<c::utf8>>}.root-servers.net" end)

  def start_link(_) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def from_dig(type, domain, server) do
    type = String.upcase(type)

    cmd_lines("dig", ["@#{server}", type, domain])
    |> Stream.map(&Regex.named_captures(~r/#{type}\t(?<host>\S+)/, &1)["host"])
    |> Enum.filter(& &1)
  end

  def from_ns(domain, server) do
    from_dig("NS", domain, server)
  end

  def from_soa(domain, server) do
    from_dig("SOA", domain, server)
  end

  def from_whois(domain, _) do
    cmd_lines("whois", [domain])
    |> Stream.map(&Regex.named_captures(~r/^nserver\S*\s*(?<host>\S+)/, &1)["host"])
    |> Stream.filter(& &1)
    |> Enum.map(&String.downcase/1)
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
      result = [&from_ns/2, &from_soa/2, &from_whois/2]
               |> Stream.map(fn f -> f.("#{Enum.join(segments, ".")}", server) end)
               |> Enum.find([], fn l -> !Enum.empty?(l) end)
      Agent.update(__MODULE__, &(Map.put(&1, segments, result)))

      result
    end
  end

  def get(fqdn) do
    fqdn |> String.split(".") |> get_for_segments()
  end

  defp cmd_lines(cmd, args) do
    IO.puts(Enum.join([cmd] ++ args, " "))
    {resp, 0} = System.cmd(cmd, args)
    String.split(resp, "\n")
  end
end
