defmodule OfferService.Infrastructure.AirFrance.AirlineSoapRepositoryTest do
  use ExUnit.Case, async: true
  import Support.Fixtures

  @repository OfferService.Infrastructure.AirFrance.AirlineSoapRepository

  @tag :integration
  test "Returns cheapest offer from Air France service" do
    preference = a_flight_preference(departure_date: ~D[2019-09-28])
    assert a_offer(price: 50911, airline: "AF") == @repository.retrieve_cheapest_offer(preference)
  end

  @tag :integration
  test "Returns nil when there is no response" do
    preference = a_flight_preference(departure_date: ~D[2016-08-15])
    assert nil == @repository.retrieve_cheapest_offer(preference)
  end
end
