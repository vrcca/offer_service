defmodule OfferService.Infrastructure.BritishAirlines.AirlineSoapRepository do
  require Logger

  alias OfferService.Domain.{FlightPreferences, AirlineRepository}
  alias OfferService.Infrastructure.BritishAirlines.{SoapRequestConverter, SoapResponseConverter}

  @behaviour AirlineRepository

  @impl AirlineRepository
  def retrieve_cheapest_offer(preferences = %FlightPreferences{}) do
    request = SoapRequestConverter.convert(preferences)

    with {:ok, response} <- call_air_shopping(request),
         %HTTPoison.Response{body: body} <- response do
      body
      |> SoapResponseConverter.convert_to_domain_stream()
      |> get_first()
    else
      e ->
        Logger.error("An error occurred! #{inspect(e)}")
        nil
    end
  end

  defp call_air_shopping(request) do
    HTTPoison.post(air_shopping_resource(), request, make_headers())
  end

  # FIXME: Move this to a configuration file (get from environment)
  # https//test.api.ba.com/
  defp air_shopping_resource() do
    "http://localhost:7777/selling-distribution/AirShopping/V2"
  end

  defp make_headers() do
    %{
      "Content-Type" => "application/xml",
      "Soapaction" => "AirShoppingV01"
    }
    |> Map.put("Client-Key", retrieve_client_key())
  end

  # FIXME: Move this to a configuration file (get from environment)
  defp retrieve_client_key(), do: "***REMOVED***"

  defp get_first(offers) do
    offers
    |> Stream.take(1)
    |> Enum.to_list()
    |> case do
      [] -> nil
      [offer] -> offer
    end
  end
end
