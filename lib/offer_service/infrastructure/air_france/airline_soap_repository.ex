defmodule OfferService.Infrastructure.AirFrance.AirlineSoapRepository do
  require Logger

  alias OfferService.Domain.{FlightPreferences, AirlineRepository}
  alias OfferService.Infrastructure.AirFrance.{SoapRequestConverter, SoapResponseConverter}

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
  # https//test.api.ba.com
  # https://ndc-rct.airfranceklm.com
  defp air_shopping_resource() do
    "http://localhost:8888/passenger/distribmgmt/001448v01/EXT"
  end

  defp make_headers() do
    %{
      "Content-Type" => "text/xml",
      "SOAPAction" =>
        "\"http://www.af-klm.com/services/passenger/ProvideAirShopping/provideAirShopping\""
    }
    |> Map.put("api_key", retrieve_client_key())
  end

  # FIXME: Move this to a configuration file (get from environment)
  defp retrieve_client_key(), do: ""

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
