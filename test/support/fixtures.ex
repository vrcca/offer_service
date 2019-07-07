defmodule Support.Fixtures do
  use Plug.Test

  alias OfferService.Domain.{Offer, Flight, FlightPreferences}

  def a_flight_preference(opts \\ []) do
    FlightPreferences.new(
      origin: "MUC",
      destination: "LHR",
      departure_date: ~D[2019-07-17]
    )
    |> struct(opts)
  end

  def a_offer(opts) do
    Offer.new(flight: "AF", price: 100)
    |> struct(opts)
  end

  def a_flight(opts \\ []) do
    Flight.new(
      airline: "AF",
      origin: "MUC",
      destination: "LHR",
      departure_date: ~D[2019-07-17],
      arrival_date: ~D[2019-07-17]
    )
    |> struct(opts)
  end

  def a_cheap_offer_request(params) when is_list(params) do
    params = Enum.into(params, %{})

    conn(:get, "/findCheapestOffer", params)
    |> put_req_header("content-type", "application/json")
    |> put_req_header("accept", "application/json")
  end
end
