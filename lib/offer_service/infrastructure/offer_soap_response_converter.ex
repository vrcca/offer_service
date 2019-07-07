defmodule OfferService.Infrastructure.OfferSoapResponseConverter do
  import SweetXml

  alias OfferService.Domain.Offer

  def convert_to_domain_stream("", _, _, _) do
    []
  end

  def convert_to_domain_stream(payload, tags_to_stream, price_xpath, airline_xpath) do
    payload
    |> stream_tags(tags_to_stream, discard: tags_to_stream)
    |> to_domain_stream(price_xpath, airline_xpath)
  end

  defp to_domain_stream(offers, price_xpath, airline_xpath) do
    offers
    |> Stream.map(fn {_, offer} ->
      price =
        offer
        |> xpath(price_xpath)
        |> convert_price_to_cents()

      airline = offer |> xpath(airline_xpath)
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
