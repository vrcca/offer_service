defmodule OfferService.Interfaces.Router do
  use Plug.Router

  alias OfferService.Application.CheapestOfferSearch

  alias OfferService.Interfaces.{
    ResponseContentTypePlug,
    FlightPreferenceRequestConverter,
    CheapestOfferResponseConverter
  }

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(:match)
  plug(ResponseContentTypePlug, content_type: "application/json")
  plug(:dispatch)

  get "/findCheapestOffer" do
    with {:ok, preference} <- FlightPreferenceRequestConverter.convert(conn) do
      result =
        preference
        |> CheapestOfferSearch.search()
        |> CheapestOfferResponseConverter.convert()

      send_resp(conn, 200, result)
    else
      error = {:error, _reason} ->
        response = CheapestOfferResponseConverter.convert(error)
        send_resp(conn, 400, response)
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
