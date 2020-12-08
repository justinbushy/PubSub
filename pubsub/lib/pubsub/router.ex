defmodule PubSub.Router do
  use Plug.Router

  plug Plug.Logger, log: :debug
  plug :match
  plug Plug.Parsers, parsers: [:json], pass: ["application/json"], json_decoder: Jason
  plug :dispatch

  post "/topic" do
    conn.body_params["topic_name"]
    |> PubSub.TopicCache.topic_process()

    send_resp(conn, 200, "Created topic")
  end

  put "/topic" do
    message = conn.body_params["message"]
    conn.body_params["topic_name"]
    |> PubSub.TopicCache.topic_process()
    |> PubSub.Server.publish(message)

    send_resp(conn, 200, "Published to topic.")
  end

  match _ do
    send_resp(conn, 404, "Oops! Nothing exists for the path given.")
  end
end
