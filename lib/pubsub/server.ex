defmodule PubSub.Server do
  use GenServer

  def start do
    GenServer.start(__MODULE__, [], name: __MODULE__)
  end

  def register(topic_name) do
    GenServer.cast(__MODULE__, {:register, self(), topic_name})
  end

  def get_subscribers(topic_name) do
    GenServer.call(__MODULE__, {:subscribers, topic_name})
  end

  def publish(topic_name, message) do
    GenServer.cast(__MODULE__, {:publish, topic_name, message})
  end

  @impl GenServer
  def init(_) do
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:subscribers, topic_name}, _, state) do
    subscribers = PubSub.Topics.get_subscribers(state, topic_name)
    {:reply, subscribers, state}
  end

  @impl GenServer
  def handle_cast({:publish, topic_name, message}, state) do
    {:ok, topic} = Map.fetch(state, topic_name)
    Enum.each(topic.subscribers, fn subscriber -> send(subscriber, message) end)
    {:noreply, state}
  end

  @impl GenServer
  def handle_cast({:register, pid, topic_name}, state) do
    new_state = PubSub.Topics.register_subscriber(state, topic_name, pid)
    {:noreply, new_state}
  end
end
