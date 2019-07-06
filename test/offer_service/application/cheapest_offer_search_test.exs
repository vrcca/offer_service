defmodule OfferService.Application.CheapestOfferSearchTest do
  use ExUnit.Case, async: true
  import Mox
  import Support.Fixtures

  @search OfferService.Application.CheapestOfferSearch
  @british_repository OfferService.Infrastructure.BritishAirlinesMockRepository
  @airfrance_repository OfferService.Infrastructure.AirFranceMockRepository

  setup :verify_on_exit!

  describe "search/2" do
    test "searches all airlines for cheapest flight offer" do
      preferences = a_flight_preference()

      british_offer = a_offer(price: 2000)
      airfrance_offer = a_offer(price: 1000)

      @british_repository
      |> expect(:search_offers, fn ^preferences -> [british_offer] end)

      @airfrance_repository
      |> expect(:search_offers, fn ^preferences -> [airfrance_offer] end)

      repositories = [@british_repository, @airfrance_repository]

      assert airfrance_offer = @search.search(preferences, repositories)
    end
  end
end
