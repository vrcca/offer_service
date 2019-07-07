defmodule OfferService.Infrastructure.OfferXmlConverter do
  import SweetXml

  alias OfferService.Domain.Offer

  def convert_to_domain_stream("", _mappings) do
    []
  end

  def convert_to_domain_stream(payload, %{
        root_tags: root_tags,
        price_xpath: price_xpath,
        airline_xpath: airline_xpath
      }) do
    payload
    |> stream_tags(root_tags, discard: root_tags)
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
