defmodule OfferService.Infrastructure.BritishAirlines.SoapRequestConverterTest do
  use ExUnit.Case

  import Support.Fixtures

  @converter OfferService.Infrastructure.BritishAirlines.SoapRequestConverter

  test "converts preference to SOAP request using template" do
    preferences = a_flight_preference(departure_date: ~D[2018-01-01])
    request = @converter.convert(preferences)
    assert request =~ "AirportCode>#{preferences.origin}"
    assert request =~ "AirportCode>#{preferences.destination}"
    assert request =~ "Date>2018-01-01"
  end
end
