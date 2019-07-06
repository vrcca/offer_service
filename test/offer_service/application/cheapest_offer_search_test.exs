defmodule OfferService.Application.CheapestOfferSearchTest do
  use ExUnit.Case, async: true
  import Mox
  import Support.Fixtures

  @search OfferService.Application.CheapestOfferSearch
  @british_repository OfferService.Infrastructure.BritishAirlinesMockRepository
  @airfrance_repository OfferService.Infrastructure.AirFranceMockRepository

  setup :verify_on_exit!

  setup do
    %{repositories: [@british_repository, @airfrance_repository]}
  end

  describe "search/2" do
    test "searches all airlines for cheapest flight offer", %{repositories: repos} do
      preferences = a_flight_preference()

      british_offer = a_offer(price: 2000)
      airfrance_offer = a_offer(price: 1000)

      @british_repository
      |> expect(:search_offers, fn ^preferences -> [british_offer] end)

      @airfrance_repository
      |> expect(:search_offers, fn ^preferences -> [airfrance_offer] end)

      assert airfrance_offer = @search.search(preferences, repos)
    end

    test "returns empty offers when there is none", %{repositories: repos} do
      @british_repository
      |> expect(:search_offers, fn _prefs -> [] end)

      @airfrance_repository
      |> expect(:search_offers, fn _prefs -> [] end)

      assert nil == @search.search(a_flight_preference(), repos)
    end
  end
end
