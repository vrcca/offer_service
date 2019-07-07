defmodule OfferService.Infrastructure.AirFrance.SoapRequestConverterTest do
  use ExUnit.Case

  import Support.Fixtures

  @converter OfferService.Infrastructure.AirFrance.SoapRequestConverter

  setup do
    %{preferences: a_flight_preference()}
  end

  test "converts preference to SOAP request using template", %{preferences: preferences} do
    request = @converter.convert(preferences)
    assert request =~ "AirportCode>#{preferences.origin}"
    assert request =~ "AirportCode>#{preferences.destination}"
    assert request =~ "Date>" <> Date.to_string(preferences.departure_date)
  end
end
