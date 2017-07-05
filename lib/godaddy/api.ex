defmodule Godaddy.Api do
  @moduledoc"""
  Make generic HTTP calls a web service.  Please
  update (or remove) the tests to a sample service
  in the examples below.
  """

  def url, do: Application.get_env(:godaddy, :api_url)
  def key, do: Application.get_env(:godaddy, :api_key)
  def secret, do: Application.get_env(:godaddy, :api_secret)

  @doc"""
  Retrieve data from the API using either :get or :post
  """
  def call(:get, %{source: source, headers: headers}), do: get(source, headers)
  def call(:get, %{source: source}), do: get(source)
  def call(:post, %{source: source, body: body, headers: headers}), do: post(source, body, headers)
  def call(:post, %{source: source, body: body}), do: post(source, body)
  def call(:post, %{source: source}), do: post(source)
  def call(:patch, %{source: source, body: body, headers: headers}), do: patch(source, body, headers)
  def call(:patch, %{source: source, body: body}), do: patch(source, body)
  def call(:patch, %{source: source}), do: patch(source)

  @doc"""
  Make an API call using GET.  Optionally provide any required headers
  """
  def get(source), do: get(source, %{})
  def get(source, headers) do
    url() <> source
    |> HTTPoison.get(encode_headers(headers))
    |> parse
  end

  @doc"""
  Make an API call using POST.  Optionally provide any required data and headers
  """
  def post(source), do: post(source, %{}, %{})
  def post(source, body), do: post(source, body, %{})
  def post(source, body, headers) do
    url() <> source
    |> HTTPoison.post(
         encode_body(headers[:body_type] || headers[:content_type], body),
         encode_headers(headers)
       )
    |> parse
  end

  @doc"""
  Make an API call using PATCH.  Optionally provide any required data and headers
  """
  def patch(source), do: patch(source, %{}, %{})
  def patch(source, body), do: patch(source, body, %{})
  def patch(source, body, headers) do
    url() <> source
    |> HTTPoison.patch(
         encode_body(headers[:body_type] || headers[:content_type], body),
         encode_headers(headers)
       )
    |> parse
  end

  @doc"""
  Encode the provided hash map for the URL.

  ## Examples

      iex> Godaddy.Api.encode_body(%{a: "one", b: "two"})
      "{\\"b\\":\\"two\\",\\"a\\":\\"one\\"}"

      iex> Godaddy.Api.encode_body(%{a: "o ne"})
      "{\\"a\\":\\"o ne\\"}"

      iex> Godaddy.Api.encode_body(nil, %{a: "o ne"})
      "{\\"a\\":\\"o ne\\"}"

      iex> Godaddy.Api.encode_body("application/x-www-form-urlencoded", %{a: "o ne"})
      "a=o+ne"

      iex> Godaddy.Api.encode_body("application/json", %{a: "b"})
      "{\\"a\\":\\"b\\"}"

  """
  def encode_body(map), do: encode_body(nil, map)
  def encode_body(nil, map), do: encode_body("application/json", map)
  def encode_body("application/x-www-form-urlencoded", map), do: URI.encode_query(map)
  def encode_body("application/json", map), do: Poison.encode!(map)
  def encode_body(_, map), do: encode_body(nil, map)

  @doc"""
  Build the headers for your API

  ## Examples

      iex> Godaddy.Api.encode_headers(%{content_type: "application/json", ssokey: {"pqr123", "mno456"}})
      [{"Content-Type", "application/json"}, {"Authorization", "sso-key pqr123:mno456"}]

      iex> Godaddy.Api.encode_headers(%{ssokey: {"pqr123", "mno456"}})
      [{"Content-Type", "application/json"}, {"Authorization", "sso-key pqr123:mno456"}]

      iex> Godaddy.Api.encode_headers(%{})
      [{"Content-Type", "application/json"}, {"Authorization", "sso-key abc123:def456"}]

      iex> Godaddy.Api.encode_headers()
      [{"Content-Type", "application/json"}, {"Authorization", "sso-key abc123:def456"}]

      iex> Godaddy.Api.encode_headers(nil)
      [{"Content-Type", "application/json"}, {"Authorization", "sso-key abc123:def456"}]

  """
  def encode_headers(), do: encode_headers(%{})
  def encode_headers(nil), do: encode_headers(%{})
  def encode_headers(data) do
    %{content_type: "application/json", ssokey: {key(), secret()}}
    |> Map.merge(data)
    |> reject_nil
    |> Enum.map(&header/1)
    |> Enum.reject(&is_nil/1)
  end
  defp header({:ssokey, {key, secret}}), do: {"Authorization", "sso-key #{key}:#{secret}"}
  defp header({:content_type, content_type}), do: {"Content-Type", content_type}
  defp header({:body_type, _}), do: nil

  defp parse({:ok, %HTTPoison.Response{body: body, status_code: 200}}) do
    {:ok, body}
  end
  defp parse({:ok, %HTTPoison.Response{body: body, status_code: 204}}) do
    {:ok, body}
  end
  defp parse({:ok, %HTTPoison.Response{status_code: code} = response}) do
    IO.inspect(response)
    {:error, "Expected a 200, received #{code}"}
  end
  defp parse({:error, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end

  defp reject_nil(map) do
    map
    |> Enum.reject(fn{_k,v} -> v == nil end)
    |> Enum.into(%{})
  end

end