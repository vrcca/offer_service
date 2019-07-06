defmodule OfferService.Application.CheapestOfferSearch do
  alias OfferService.Domain.{FlightPreferences, Offer}

  def search(prefs = %FlightPreferences{}, repositories) do
    prefs
    |> search_matching_offers(repositories)
    |> select_cheapest()
  end

  defp search_matching_offers(prefs, repositories) do
    repositories
    |> stream_in_parallel(fn repo -> repo.retrieve_cheapest_offer(prefs) end)
    |> Stream.filter(fn result -> elem(result, 0) == :ok end)
    |> Stream.filter(fn {:ok, offer} -> offer != nil end)
    |> Stream.map(fn {:ok, offer} -> offer end)
  end

  defp select_cheapest(offers) do
    offers
    |> Enum.min_by(fn %Offer{price: price} -> price end, fn -> nil end)
  end

  defp stream_in_parallel(enumerables, fun) do
    opts = [max_concurrency: length(enumerables)]

    Task.Supervisor.async_stream(
      OfferService.AirlineTaskSupervisor,
      enumerables,
      fun,
      opts
    )
  end
end
