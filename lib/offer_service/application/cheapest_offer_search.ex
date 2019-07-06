defmodule OfferService.Application.CheapestOfferSearch do
  alias OfferService.Domain.{FlightPreferences, Offer}

  def search(prefs = %FlightPreferences{}, repositories) do
    prefs
    |> search_matching_offers(repositories)
    |> select_cheapest()
  end

  defp search_matching_offers(prefs, repositories) do
    Stream.flat_map(repositories, fn repo ->
      repo.search_offers(prefs)
    end)
  end

  defp select_cheapest(offers) do
    offers
    |> Enum.min_by(fn %Offer{price: price} -> price end)
  end
end
