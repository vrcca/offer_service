defmodule OfferService.Infrastructure.OfferXmlConverterTest do
  use ExUnit.Case, async: true

  import Support.Fixtures
  import SweetXml

  @response_converter OfferService.Infrastructure.OfferXmlConverter

  @mappings %{
    root_tags: [:Offers],
    price_xpath: ~x"./Price/text()"s,
    airline_xpath: ~x"./@AirlineID"s
  }

  test "correctly retrieves prices and its airline" do
    payload = File.read!("test/samples/offer_converter_sample.xml")

    response =
      @response_converter.convert_to_domain_stream(payload, @mappings)
      |> Enum.to_list()

    assert response == [
             a_offer(price: 1299, airline: "BA"),
             a_offer(price: 7712, airline: "AF")
           ]
  end

  test "invalid payload should return empty responses" do
    response =
      @response_converter.convert_to_domain_stream("<Empty></Empty>", @mappings)
      |> Enum.take(1)

    assert response == []
  end

  test "empty payload should return empty responses" do
    response =
      @response_converter.convert_to_domain_stream("", @mappings)
      |> Enum.take(1)

    assert [] == response
  end
end
