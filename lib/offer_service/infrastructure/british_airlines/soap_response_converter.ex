defmodule OfferService.Infrastructure.BritishAirlines.SoapResponseConverter do
  import SweetXml

  alias OfferService.Domain.Offer

  def convert_to_domain_stream("") do
    []
  end

  def convert_to_domain_stream(payload) do
    payload
    |> stream_tags([:AirlineOffer], discard: [:AirlineOffer])
    |> to_domain_stream()
  end

  defp to_domain_stream(offers) do
    offers
    |> Stream.map(fn {_, offer} ->
      price =
        offer
        |> xpath(~x"./TotalPrice/SimpleCurrencyPrice/text()"s)
        |> convert_price_to_cents()

      airline = offer |> xpath(~x"./OfferID/@Owner"s)
      Offer.new(price: price, airline: airline)
    end)
  end

  defp convert_price_to_cents(price) do
    price
    |> String.trim()
    |> String.replace(~r/[,.]/, "")
    |> String.to_integer()
  end
end
