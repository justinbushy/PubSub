defmodule PubSub.Server do
  use GenServer
  require Logger

  def start_link(topic_name) do
    Logger.info("Starting Topic Server for #{topic_name}...")
    GenServer.start_link(PubSub.Server, topic_name, name: via_tuple(topic_name))
  end

  def publish(server_pid, message) do
    GenServer.cast(server_pid, {:publish, message})
  end

  def via_tuple(topic_name) do
    PubSub.TopicRegistry.via_tuple({__MODULE__, topic_name})
  end

  @impl GenServer
  def init(topic_name) do
    {:ok, topic_name}
  end

  @impl GenServer
  def handle_cast({:publish, message}, topic_name) do

    Registry.dispatch(Registry.WebSocket, "/ws/#{topic_name}", fn entries ->
      for {pid, _} <- entries, do: send(pid, message)
    end)
    {:noreply, topic_name}
  end
end
