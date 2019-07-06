defmodule OfferService.Infrastructure.BritishAirlines.SoapResponseConverter do
  import SweetXml

  alias OfferService.Domain.Offer

  def convert(payload) do
    payload
    |> stream_tags([:AirlineOffer], discard: [:AirlineOffer])
    |> Stream.map(fn {_, offer} ->
      price =
        offer
        |> xpath(~x"./TotalPrice/SimpleCurrencyPrice/text()"s)
        |> convert_price_to_cents()

      airline = offer |> xpath(~x"./OfferID/@Owner"s)
      Offer.new(price: price, airline: airline)
    end)
    |> Stream.take(1)
    |> Enum.to_list()
  end

  defp convert_price_to_cents(price) do
    price
    |> String.trim()
    |> String.replace(~r/[,.]/, "")
    |> String.to_integer()
  end
end
