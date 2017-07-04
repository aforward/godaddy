defmodule Godaddy.Client do
  use FnExpr

  @moduledoc"""
  Access service functionality through Elixir functions,
  wrapping the underlying HTTP API calls.

  This is where you will want to write your custom
  code to access your API, and it is probably best
  to make those calls through your Worker.

    Godaddy.Worker.http/2
    Godaddy.Worker.get/2
    Godaddy.Worker.post/3
  """

  alias Godaddy.Api

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

  defp parse({:ok, body}), do: Poison.decode!(body)

end


