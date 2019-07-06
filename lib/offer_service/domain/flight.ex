defmodule OfferService.Domain.Flight do
  defstruct airline: nil,
            origin: nil,
            destination: nil,
            departure_date: nil,
            arrival_date: nil

  def new(opts) do
    struct(__MODULE__, opts)
  end
end
