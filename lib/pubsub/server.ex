defmodule PubSub.Server do
  use GenServer
  require Logger

  def start_link(topic_name) do
    Logger.info("Starting Topic Server...")
    GenServer.start_link(PubSub.Server, topic_name, name: via_tuple(topic_name))
  end

  def register(server_pid) do
    GenServer.cast(server_pid, {:register, self()})
  end

  def get_subscribers(server_pid) do
    GenServer.call(server_pid, :subscribers)
  end

  def publish(server_pid, message) do
    GenServer.cast(server_pid, {:publish, message})
  end

  def via_tuple(topic_name) do
    PubSub.Registry.via_tuple({__MODULE__, topic_name})
  end

  @impl GenServer
  def init(topic_name) do
    {:ok, {topic_name, []}}
  end

  @impl GenServer
  def handle_call(:subscribers, _, state) do
    {_, subscribers} = state
    {:reply, state, subscribers}
  end

  @impl GenServer
  def handle_cast({:publish, message}, state) do
    {_, subscribers} = state
    Enum.each(subscribers, fn subscriber -> send(subscriber, message) end)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:register, pid}, state) do
    {topic_name, subscribers} = state
    {:noreply, {topic_name, Enum.uniq([pid | subscribers])}}
  end
end
