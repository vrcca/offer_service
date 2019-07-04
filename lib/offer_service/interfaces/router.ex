defmodule OfferService.Interfaces.Router do
  use Plug.Router

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  plug(Plug.Logger)

  plug(:match)
  plug(:dispatch)

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
