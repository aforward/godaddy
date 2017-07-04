defmodule Godaddy.Worker do
  use GenServer

  ### Public API

  def start_link() do
    {:ok, _pid} = GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def http(method, data) do
    GenServer.call(Godaddy.Worker, {:http, method, data})
  end

  def post(url, body, headers) do
    GenServer.call(Godaddy.Worker, {:post, url, body, headers})
  end

  def get(url, headers) do
    GenServer.call(Godaddy.Worker, {:get, url, headers})
  end

  ### Server Callbacks

  def init() do
    {:ok, {}}
  end

  def handle_call({:http, method, data}, _from, state) do
    answer = Godaddy.Api.call(method, data)
    {:reply, answer, state}
  end

  def handle_call({:post, url, body, headers}, _from, state) do
    answer = Godaddy.Api.post(url, body, headers)
    {:reply, answer, state}
  end

  def handle_call({:get, url, headers}, _from, state) do
    answer = Godaddy.Api.get(url, headers)
    {:reply, answer, state}
  end

end
