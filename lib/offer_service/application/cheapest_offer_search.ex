defmodule OfferService.Application.CheapestOfferSearch do
  require Logger
  alias OfferService.Domain.{FlightPreferences, Offer}

  @repositories Application.fetch_env!(:offer_service, :airline_repositories)

  def search(preference = %FlightPreferences{}) do
    preference
    |> search_matching_offers()
    |> select_cheapest()
  end

  defp search_matching_offers(preference) do
    stream_in_parallel(@repositories, fn repo ->
      Logger.info("Retriving data from #{inspect(repo)}")
      repo.retrieve_cheapest_offer(preference)
    end)
    |> Stream.filter(&filter_invalid_offer/1)
    |> Stream.map(fn {:ok, offer} -> offer end)
  end

  defp stream_in_parallel(enumerables, fun) do
    Task.Supervisor.async_stream_nolink(
      OfferService.AirlineTaskSupervisor,
      enumerables,
      fun
    )
  end

  defp filter_invalid_offer({:ok, %Offer{}}), do: true
  defp filter_invalid_offer({:ok, nil}), do: false

  defp filter_invalid_offer(error) do
    Logger.warn("An error occurred on retrieving cheapest offer! Error: #{inspect(error)}")
    false
  end

  defp select_cheapest(offers) do
    offers
    |> Enum.min_by(fn %Offer{price: price} -> price end, fn -> nil end)
  end
end
