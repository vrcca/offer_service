defmodule OfferService.Infrastructure.AirFrance.SoapResponseConverterTest do
  use ExUnit.Case, async: true

  import Support.Fixtures

  @response_converter OfferService.Infrastructure.AirFrance.SoapResponseConverter

  test "correctly retrieves the first price from payload" do
    payload = File.read!("test/samples/air_france_airshopping_sample.xml")
    response = @response_converter.convert_to_domain_stream(payload) |> Enum.take(1)
    assert [a_offer(price: 50911, airline: "AF")] == response
  end

  test "invalid payload should return empty responses" do
    assert [] == @response_converter.convert_to_domain_stream("<Empty></Empty>") |> Enum.take(1)
  end

  test "empty payload should return empty responses" do
    assert [] == @response_converter.convert_to_domain_stream("") |> Enum.take(1)
  end
end
