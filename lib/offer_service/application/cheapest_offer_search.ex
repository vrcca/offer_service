defmodule OfferService.Application.CheapestOfferSearch do
  alias OfferService.Domain.{FlightPreferences, Offer}

  @repositories Application.fetch_env!(:offer_service, :airline_repositories)

  def search(preference = %FlightPreferences{}) do
    preference
    |> search_matching_offers()
    |> select_cheapest()
  end

  defp search_matching_offers(preference) do
    stream_in_parallel(@repositories, fn repo -> repo.retrieve_cheapest_offer(preference) end)
    |> Stream.filter(fn result -> elem(result, 0) == :ok end)
    |> Stream.filter(fn {:ok, offer} -> offer != nil end)
    |> Stream.map(fn {:ok, offer} -> offer end)
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

  defp select_cheapest(offers) do
    offers
    |> Enum.min_by(fn %Offer{price: price} -> price end, fn -> nil end)
  end
end
