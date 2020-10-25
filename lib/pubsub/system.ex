defmodule PubSub.System do
  def start_link do
    Supervisor.start_link(
      [
        PubSub.Registry,
        PubSub.TopicCache
      ],
      strategy: :one_for_one
    )
  end
end
