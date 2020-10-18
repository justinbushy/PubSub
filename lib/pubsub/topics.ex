defmodule PubSub.Topics do
  defstruct subscribers: []

  def get_subscribers(topics, topic_name) do
    case Map.fetch(topics, topic_name) do
      {:ok, result} -> result.subscribers
      :error -> "Topic does not exist."
    end
  end

  def register_subscriber(topics, topic_name, pid) do
    case Map.fetch(topics, topic_name) do
      {:ok, topic} ->
        %{topics | topic_name => %PubSub.Topics{subscribers: Enum.uniq([pid | topic.subscribers])}}
      :error ->
        Map.put(topics, topic_name, %PubSub.Topics{subscribers: [pid]})
    end
  end
end
