defmodule OfferService.Infrastructure.BritishAirlines.SoapResponseConverter do
  import SweetXml

  alias OfferService.Domain.Offer

  def convert(payload) do
    payload
    |> stream_tags([:AirlineOffer], discard: [:AirlineOffer])
    |> Stream.map(fn {_, offer} ->
      %{
        airline: offer |> xpath(~x"./OfferID/@Owner"s),
        price: offer |> xpath(~x"./TotalPrice/SimpleCurrencyPrice/text()"s)
      }
    end)
    |> Stream.map(fn offer = %{price: price} ->
      Map.put(offer, :price, convert_price_to_cents(price))
    end)
    |> Stream.map(fn offer = %{} -> Offer.new(Enum.into(offer, [])) end)
    |> Stream.take(1)
    |> Enum.to_list()
  end

  defp convert_price_to_cents(price) do
    price
    |> String.replace(~r/[,.]/, "")
    |> String.trim()
    |> String.to_integer()
  end
end
