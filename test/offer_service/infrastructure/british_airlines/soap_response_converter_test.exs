defmodule OfferService.Infrastructure.BritishAirlines.SoapResponseConverterTest do
  use ExUnit.Case, async: true

  import Support.Fixtures

  @response_converter OfferService.Infrastructure.BritishAirlines.SoapResponseConverter

  test "correctly retrieves the first price from payload" do
    payload = File.read!("test/samples/british_airlines_airshopping_sample.xml")
    response = @response_converter.convert(payload)
    offer = a_offer(price: 9414, airline: "BA")
    assert [^offer] = response
  end

  test "empty payload should return empty responses" do
    assert [] = @response_converter.convert("<Empty></Empty>")
  end
end
