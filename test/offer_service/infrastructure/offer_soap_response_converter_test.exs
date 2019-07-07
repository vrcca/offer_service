defmodule OfferService.Infrastructure.OfferSoapResponseConverterTest do
  use ExUnit.Case, async: true

  import Support.Fixtures
  import SweetXml

  @response_converter OfferService.Infrastructure.OfferSoapResponseConverter

  @root_tags [:Offers]
  @price_xpath ~x"./Price/text()"s
  @airline_xpath ~x"./@AirlineID"s

  test "correctly retrieves the first price from Air France payload" do
    payload = File.read!("test/samples/offer_converter_sample.xml")

    response =
      @response_converter.convert_to_domain_stream(
        payload,
        @root_tags,
        @price_xpath,
        @airline_xpath
      )
      |> Enum.to_list()

    assert [
             a_offer(price: 1299, airline: "BA"),
             a_offer(price: 7712, airline: "AF")
           ] == response
  end

  test "invalid payload should return empty responses" do
    assert [] ==
             @response_converter.convert_to_domain_stream(
               "<Empty></Empty>",
               @root_tags,
               @price_xpath,
               @airline_xpath
             )
             |> Enum.take(1)
  end

  test "empty payload should return empty responses" do
    assert [] ==
             @response_converter.convert_to_domain_stream(
               "",
               @root_tags,
               @price_xpath,
               @airline_xpath
             )
             |> Enum.take(1)
  end
end
