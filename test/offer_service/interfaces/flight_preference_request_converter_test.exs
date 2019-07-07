defmodule OfferService.Interfaces.FlightPreferenceRequestConverterTest do
  use ExUnit.Case, async: true

  import Support.Fixtures

  @converter OfferService.Interfaces.FlightPreferenceRequestConverter

  test "translates request to domain" do
    params = [origin: "BER", destination: "LHR", departureDate: "2019-07-17"]
    conn = a_cheap_offer_request(params)
    {:ok, preference} = @converter.convert(conn)

    assert preference ==
             a_flight_preference(origin: "BER", destination: "LHR", departure_date: "2019-07-17")
  end

  test "missing \"origin\" property return error" do
    params = [orig: "BER", destination: "LHR", departureDate: "2019-07-17"]
    conn = a_cheap_offer_request(params)
    assert {:error, reason} = @converter.convert(conn)
    assert reason == "Missing query parameter: origin"
  end

  test "missing \"destination\" property return error" do
    params = [origin: "BER", desti_nation: "LHR", departureDate: "2019-07-17"]
    conn = a_cheap_offer_request(params)
    assert {:error, reason} = @converter.convert(conn)
    assert reason == "Missing query parameter: destination"
  end

  test "missing \"departureDate\" property return error" do
    params = [origin: "BER", destination: "LHR", departure_date: "2019-07-17"]
    conn = a_cheap_offer_request(params)
    assert {:error, reason} = @converter.convert(conn)
    assert reason == "Missing query parameter: departureDate"
  end

  test "missing all properties return error" do
    params = [origina: "BER", destinat: "LHR", departure: "2019-07-17"]
    conn = a_cheap_offer_request(params)
    assert {:error, reason} = @converter.convert(conn)
    assert reason == "Missing query parameter: origin, destination, departureDate"
  end
end
