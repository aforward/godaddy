defmodule Godaddy do
  @moduledoc"""
  A minimal library for posting messages to the GoDaddy API.

  The API keys must be configured as follows:

      config :godaddy,
        api_key: "abc123",
        api_secret: "def456"

  And can be located at [GoDaddy API Keys](https://developer.godaddy.com/keys/).
  """

  @doc"""
  Make a call directly to GoDaddy API

  To make a call using GET, the API looks similar to

      Godaddy.call(:get, %{source: "/v1/domains"})

  To make a POST (or PATCH or PUT), the API looks similar to

      Godaddy.call(
        :patch,
        %{source: "/v1/domains/mydomain.com",
          body: %{"nameServers" => ["ns1.cloudprovider.com", "ns2.cloudprovider.com"]}})

  The responses will be raw binary (aka strings) similar to

      {:ok, "{\"domain\": \"mydomain.com\", ...}"}

  """
  defdelegate call(method, parts), to: Godaddy.Api


  @doc"""
  List your domains

      Godaddy.domains

  The results will be a map with domain name as key, and the value
  being some of the high level data that GoDaddy stores for you.

  For example,

      %{"mydomain.com" => %{
          "createdAt" => "1999-09-21T17:36:53Z",
          "domain" => "mydomain.com",
          "domainId" => 237117477,
          "expirationProtected" => false,
          "expires" => "2024-09-22T17:36:53Z",
          "holdRegistrar" => false,
          "locked" => true,
          "privacy" => false,
          "renewAuto" => true,
          "renewDeadline" => "2024-09-21T17:36:53Z",
          "renewable" => true,
          "status" => "ACTIVE",
          "transferProtected" => false},
        "anotherd.org" => %{
          "createdAt" => "1999-09-21T18:34:00Z",
          "domain" => "anotherd.org",
          "domainId" => 241650919,
          "expirationProtected" => false,
          "expires" => "2024-09-23T18:34:00Z",
          "holdRegistrar" => false,
          "locked" => true,
          "privacy" => false,
          "renewAuto" => false,
          "renewDeadline" => "2024-09-24T11:33:59Z",
          "renewable" => true,
          "status" => "ACTIVE",
          "transferProtected" => false}}
  """
  defdelegate domains, to: Godaddy.Client

  @doc"""
  List details of one of your domains

      Godaddy.domain("mydomain.com")

  The results will be a map of key/value pairs for all the data that GoDaddy stores for you.

  For example,

        %{"authCode" => "A1B2C3",
          "contactAdmin" => %{
            "addressMailing" => %{
              "address1" => "101 Main Street",
              "address2" => "",
              "city" => "Springfield",
              "country" => "US",
              "postalCode" => "90210",
              "state" => "California"},
            "email" => "contact@email.com",
            "fax" => "",
            "nameFirst" => "James",
            "nameLast" => "Url",
            "organization" => "Woggle Inc",
            "phone" => "+1.5555551234"},
          "contactBilling" => %{
            "addressMailing" => %{
              "address1" => "101 Main Street",
              "address2" => "",
              "city" => "Springfield",
              "country" => "US",
              "postalCode" => "90210",
              "state" => "California"},
            "email" => "contact@email.com",
            "fax" => "",
            "nameFirst" => "James",
            "nameLast" => "Url",
            "organization" => "Woggle Inc",
            "phone" => "+1.5555551234"},
          "contactRegistrant" => %{
            "addressMailing" => %{
              "address1" => "101 Main Street",
              "address2" => "",
              "city" => "Springfield",
              "country" => "US",
              "postalCode" => "90210",
              "state" => "California"},
            "email" => "contact@email.com",
            "fax" => "",
            "nameFirst" => "James",
            "nameLast" => "Url",
            "organization" => "Woggle Inc",
            "phone" => "+1.5555551234"},
          "contactTech" => %{
            "addressMailing" => %{
              "address1" => "101 Main Street",
              "address2" => "",
              "city" => "Springfield",
              "country" => "US",
              "postalCode" => "90210",
              "state" => "California"},
            "email" => "contact@email.com",
            "fax" => "",
            "nameFirst" => "James",
            "nameLast" => "Url",
            "organization" => "Woggle Inc",
            "phone" => "+1.5555551234"},
            "createdAt" => "2017-09-22T18:34:00Z",
          "domain" => "mydomain.com",
          "domainId" => 12345,
          "expirationProtected" => false,
          "expires" => "2018-09-22T18:34:00Z",
          "holdRegistrar" => false,
          "locked" => true,
          "nameServers" => [
            "ns1.cloudprovider.com",
            "ns2.cloudprovider.com",
            "ns3.cloudprovider.com"],
          "privacy" => false,
          "renewAuto" => false,
          "renewDeadline" => "2018-09-21T11:33:59Z",
          "renewable" => true,
          "status" => "ACTIVE",
          "transferProtected" => false}
  """
  defdelegate domain(name), to: Godaddy.Client

  @doc"""
  Update your domain nameservers.

  You can provide either a known DNS provider (currently only `:digitalocean` supported)

      Godaddy.set_nameservers("mydomain.com", :digitalocean)

  OR, you cann provide the list directly

      Godaddy.set_nameservers("mydomain.com", ["ns1.cloudprovider.local", "ns2.cloudprovider.local"])

  The response will be `:ok` or an exception if something goes awry.

  """
  defdelegate set_nameservers(name, provider), to: Godaddy.Client

end
