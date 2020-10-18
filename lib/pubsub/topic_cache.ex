defmodule PubSub.TopicCache do
  def start_link() do
    IO.puts("Starting topic cache")

    DynamicSupervisor.start_link(
      name: __MODULE__,
      strategy: :one_for_one
    )
  end

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  # def topic_process(topic_name) do

  # end

  def start_child(topic_name) do
    DynamicSupervisor.start_child(
      __MODULE__,
      {PubSub.Topics, topic_name}
    )
  end
end
