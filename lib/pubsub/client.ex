defmodule PubSub.Client do
  # Just used for testing purposes right now
  # Client can either publish or receive,
  # doesn't really make sense for both

  def spawn_receiving_client(topic_name) do
    spawn(fn ->
      pid = PubSub.TopicCache.topic_process(topic_name)
      PubSub.Server.register(pid)
      wait_for_message()
    end)
  end

  def publish(server_pid, message) do
    PubSub.Server.publish(server_pid, message)
  end

  def wait_for_message do
    receive do
      message ->
        IO.puts("client #{inspect self()} received message: #{message}")
    end

    wait_for_message()
  end
end
