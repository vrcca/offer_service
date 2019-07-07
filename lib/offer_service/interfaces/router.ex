defmodule OfferService.Interfaces.Router do
  use Plug.Router

  alias OfferService.Application.CheapestOfferSearch
  alias OfferService.Interfaces.{FlightPreferenceRequestConverter, CheapestOfferResponseConverter}

  if Mix.env() == :dev do
    use Plug.Debugger
  end

  plug(Plug.RequestId)
  plug(Plug.Logger)

  plug(:match)
  plug(:dispatch)

  get "/findCheapestOffer" do
    with {:ok, preference} <- FlightPreferenceRequestConverter.convert(conn) do
      result =
        preference
        |> CheapestOfferSearch.search()
        |> CheapestOfferResponseConverter.convert()

      send_resp(conn, 200, result)
    end
  end

  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
