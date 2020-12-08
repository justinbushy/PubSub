defmodule PubSub.WebsocketPlug do
  @behaviour :cowboy_websocket

  def init(request, _state) do
    IO.inspect(request.path)
    state  = %{registry_key: request.path, topic_name: hd(request.path_info)}

    {:cowboy_websocket, request, state}
  end

  def websocket_init(state) do
    case PubSub.TopicCache.topic_exists?(state.topic_name) do
      true -> register_socket(state)
      false -> {:reply, {:close, "Topic does not exist"}, state}
    end
  end

  def register_socket(state) do
    Registry.WebSocket
    |> Registry.register(state.registry_key, {})

    {:reply, {:text, "Registered for topic."}, state}
  end

  def websocket_handle({:text, message}, state) do
    IO.inspect(message, label: "socket message")
    {:reply, {:text, "received message"}, state}
  end

  def websocket_info(info, state) do
    IO.puts("INFO: #{inspect info}")
    {:reply, {:text, info}, state}
  end
end
