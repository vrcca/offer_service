defmodule OfferService.Domain.Offer do
  defstruct airline: nil, price: 0

  def new(opts \\ []) do
    struct(__MODULE__, opts)
  end
end
