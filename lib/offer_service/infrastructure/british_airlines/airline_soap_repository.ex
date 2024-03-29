defmodule OfferService.Infrastructure.BritishAirlines.AirlineSoapRepository do
  require Logger
  import SweetXml

  alias OfferService.Domain.{FlightPreferences, AirlineRepository}
  alias OfferService.Infrastructure.BritishAirlines.SoapRequestConverter
  alias OfferService.Infrastructure.OfferXmlConverter

  @mappings %{
    root_tags: [:AirlineOffer],
    price_xpath: ~x"./TotalPrice/SimpleCurrencyPrice/text()"s,
    airline_xpath: ~x"./OfferID/@Owner"s
  }

  @behaviour AirlineRepository

  @impl AirlineRepository
  def retrieve_cheapest_offer(preferences = %FlightPreferences{}) do
    with request = SoapRequestConverter.convert(preferences),
         {:ok, response} <- call_air_shopping(request),
         %HTTPoison.Response{body: body} <- response do
      body
      |> convert_to_domain_stream()
      |> get_first()
    else
      e ->
        Logger.error("An error occurred! #{inspect(e)}")
        nil
    end
  end

  defp convert_to_domain_stream(payload) do
    OfferXmlConverter.convert_to_domain_stream(
      payload,
      @mappings
    )
  end

  defp get_first(offers) do
    offers
    |> Enum.take(1)
    |> case do
      [] -> nil
      [offer] -> offer
    end
  end

  defp call_air_shopping(request) do
    HTTPoison.post(air_shopping_resource(), request, make_headers(), hackney: [pool: :default])
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
end
