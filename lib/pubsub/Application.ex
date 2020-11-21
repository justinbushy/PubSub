defmodule PubSub.Application do
  use Application
  require Logger

  def start(_type, _opts) do
    children =
      [
        PubSub.Registry,
        PubSub.TopicCache,
        {Plug.Cowboy, scheme: :http, plug: PubSub.ServerPlug, options: [port: 8080]}
      ]
    opts = [strategy: :one_for_one, name: PubSub.Supervisor]

    Logger.info("Starting Application...")

    Supervisor.start_link(children, opts)
  end
end
