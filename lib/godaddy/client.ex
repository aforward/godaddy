defmodule Godaddy.Client do
  use FnExpr

  alias Godaddy.Api

  @moduledoc false

  @digitalocean_ns_servers ["ns1.digitalocean.com", "ns2.digitalocean.com", "ns3.digitalocean.com"]

  def domains do
    "/v1/domains"
    |> Api.get
    |> parse
    |> Enum.map(fn %{"domain" => domain} = data -> {domain, data} end)
    |> Enum.into(%{})
  end

  def domain(name) do
    "/v1/domains/#{name}"
    |> Api.get
    |> parse
  end

  def set_nameservers(domain, ns_servers) when is_list(ns_servers) do
    "/v1/domains/#{domain}"
    |> Api.patch(%{"domain" => domain, "nameServers" => ns_servers})
    |> parse
  end
  def set_nameservers(domain, ns_provider) when is_binary(ns_provider) do
    set_nameservers(domain, String.to_atom(ns_provider))
  end
  def set_nameservers(domain, :digitalocean), do: set_nameservers(domain, @digitalocean_ns_servers)

  defp parse({:ok, ""}), do: :ok
  defp parse({:ok, body}), do: Poison.decode!(body)

end


