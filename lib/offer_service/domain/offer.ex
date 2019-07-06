defmodule OfferService.Domain.Offer do
  defstruct flight: nil, price: 0

  def new(opts \\ []) do
    struct(__MODULE__, opts)
  end
end
