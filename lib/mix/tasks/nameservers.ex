defmodule Mix.Tasks.Godaddy.Nameservers do
  use Mix.Task

  @moduledoc"""
  A command line task to set your GoDaddy API nameservers.

  You can provide either a known DNS provider (currently only `:digitalocean` supported)

      mix godaddy.nameservers mydomain.com digitalocean

  OR, you cann provide the list directly

      mix godaddy.nameservers mydomain.com ns1.cloudprovider.local ns2.cloudprovider.local

  """

  @shortdoc "Set the nameservers for a cloudprovider, e.g. digitalocean"
  def run([domain, ns_provider]), do: _run(domain, ns_provider)
  def run([domain | ns_servers]), do: _run(domain, ns_servers)

  defp _run(domain, ns_provider_or_servers) do
    {:ok, _started} = Application.ensure_all_started(:httpoison)
    Godaddy.Client.set_nameservers(domain, ns_provider_or_servers)
    IO.puts "Updated #{domain} nameservers to #{ns_provider_or_servers |> to_s}"
  end

  defp to_s(ns_provider) when is_binary(ns_provider), do: ns_provider
  defp to_s(ns_servers), do: Enum.join(ns_servers, ", ")

end