defmodule PubSub.Client do
  # Client can either publish or receive,
  # doesn't really make sense for both

  def register(topic_name) do
    PubSub.Server.register(topic_name)
  end

  def spawn_client(topic_name) do
    spawn(fn ->
      PubSub.Server.register(topic_name)
      wait_for_message()
    end)
  end

  def publish(topic, message) do
    PubSub.Server.publish(topic, message)
  end

  def wait_for_message do
    receive do
      message ->
        IO.puts("client #{inspect self()} received message: #{message}")
    end

    wait_for_message()
  end
end
