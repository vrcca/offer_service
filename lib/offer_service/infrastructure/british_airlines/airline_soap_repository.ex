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

  defp air_shopping_resource() do
    url = Application.get_env(:offer_service, :british_airlines_api_url)
    url <> "/selling-distribution/AirShopping/V2"
  end

  defp make_headers() do
    api_key = Application.get_env(:offer_service, :british_airlines_api_key)

    %{
      "Content-Type" => "application/xml",
      "Soapaction" => "AirShoppingV01",
      "Client-Key" => api_key
    }
  end

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
