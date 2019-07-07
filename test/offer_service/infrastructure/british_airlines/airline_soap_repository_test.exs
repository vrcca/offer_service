defmodule OfferService.Infrastructure.BritishAirlines.AirlineSoapRepositoryTest do
  use ExUnit.Case, async: true
  import Support.Fixtures

  @repository OfferService.Infrastructure.BritishAirlines.AirlineSoapRepository

  @tag :integration
  test "Returns cheapest offer from british airlines service" do
    preference = a_flight_preference(departure_date: ~D[2019-09-28])
    assert a_offer(price: 9414, airline: "BA") == @repository.retrieve_cheapest_offer(preference)
  end

  @tag :integration
  test "Returns nil when there is an error" do
    preference = a_flight_preference(departure_date: ~D[2016-09-28])
    assert nil == @repository.retrieve_cheapest_offer(preference)
  end
end
