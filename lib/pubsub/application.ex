defmodule PubSub.Application do
  use Application
  require Logger

  def start(_type, _opts) do
    children =
      [
        PubSub.TopicRegistry,
        PubSub.TopicCache,
        {
          Plug.Cowboy,
          scheme: :http,
          plug: PubSub.Router,
          options: [
            dispatch: dispatch(),
            port: 8080
          ]
        },
        Registry.child_spec(
          keys: :duplicate,
          name: Registry.WebSocket
        )
      ]
    opts = [strategy: :one_for_one, name: PubSub.Supervisor]

    Logger.info("Starting Application...")

    Supervisor.start_link(children, opts)
  end

  def dispatch do
    [
      {
        :_, [
          {"/ws/[...]", PubSub.WebsocketPlug, []},
          {:_, Plug.Cowboy.Handler, {PubSub.Router, []}}
        ]
      }
    ]
  end
end
