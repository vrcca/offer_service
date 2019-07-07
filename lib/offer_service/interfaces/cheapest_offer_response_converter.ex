defmodule OfferService.Interfaces.CheapestOfferResponseConverter do
  alias OfferService.Domain.Offer

  def convert(%Offer{airline: airline, price: price}) do
    %{
      data: %{
        cheapestOffer: %{
          airline: airline,
          amount: convert_cents(price)
        }
      }
    }
    |> Jason.encode!()
  end

  def convert(nil) do
    %{
      data: %{
        cheapestOffer: nil
      }
    }
    |> Jason.encode!()
  end

  def convert({:error, reason}) do
    %{error: reason}
    |> Jason.encode!()
  end

  defp convert_cents(price) when is_integer(price), do: price / 100
end
