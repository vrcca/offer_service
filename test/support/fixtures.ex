defmodule Support.Fixtures do
  alias OfferService.Domain.{Offer, Flight, FlightPreferences}

  def a_flight_preference(opts \\ []) do
    FlightPreferences.new(
      origin: "BER",
      destination: "LHR",
      departure_date: ~D[2019-07-17]
    )
    |> struct(opts)
  end

  def a_offer(opts) do
    Offer.new(flight: a_flight(), price: 100)
    |> struct(opts)
  end

  def a_flight(opts \\ []) do
    Flight.new(
      airline: "AF",
      origin: "BER",
      destination: "LHR",
      departure_date: ~D[2019-07-17],
      arrival_date: ~D[2019-07-17]
    )
    |> struct(opts)
  end
end
