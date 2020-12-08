defmodule Client.Consumer do
  use WebSockex

  def start_link(topic_name) do
    WebSockex.start_link("ws://localhost:8080/ws/#{topic_name}", __MODULE__, {})
  end

  def handle_frame({:text, message}, state) do
    IO.inspect(message, label: "message")
    {:ok, state}
  end

  def handle_disconnect(disconnect_map, state) do
    {_, _, reason} = disconnect_map.reason
    IO.puts("Disconnected for the following reason: #{reason}")

    super(disconnect_map, state)
  end
end
