defmodule OfferService.Domain.FlightPreferences do
  defstruct origin: nil, destination: nil, departureDate: nil

  def new(opts \\ []) do
    struct(__MODULE__, opts)
  end
end
