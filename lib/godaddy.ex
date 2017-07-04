defmodule Godaddy do
  @moduledoc"""
  A client library for interacting with the Godaddy API.

  The underlying HTTP calls and done through

    Godaddy.Api

  Which are wrapped in a GenServer in

    Godaddy.Worker

  And client specific access should be placed in

    Godaddy.Client

  Your client wrapper methods should be exposed here, using defdelegate,
  for example

    defdelegate do_something, to: Godaddy.Client

  If you API is not complete, then you would also expose direct access to your
  Worker calls:

    defdelegate http(method, data), to: Godaddy.Worker
    defdelegate post(url, body, headers), to: Godaddy.Worker
    defdelegate get(url, headers), to: Godaddy.Worker
  """

end
