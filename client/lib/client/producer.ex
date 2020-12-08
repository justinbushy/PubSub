defmodule Client.Producer do
  @headers [{"content-type", "application/json"}]
  def create_topic(topic_name) do
    body = Jason.encode!(%{"topic_name" => topic_name})

    Finch.build(:post, "http://localhost:8080/topic", @headers, body)
    |> Finch.request(MyFinch)
  end

  def publish_message(topic_name, message) do
    body = Jason.encode!(%{"topic_name" => topic_name, "message" => message})

    Finch.build({:put, "http://localhost:8080/topic", @headers, body})
    |> Finch.request(MyFinch)
  end
end
