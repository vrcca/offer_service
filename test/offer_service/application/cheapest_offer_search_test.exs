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
      |> expect(:retrieve_cheapest_offer, fn ^preferences -> british_offer end)

      @airfrance_repository
      |> expect(:retrieve_cheapest_offer, fn ^preferences -> airfrance_offer end)

      assert airfrance_offer = @search.search(preferences)
    end

    test "returns empty offers when there is none" do
      @british_repository
      |> expect(:retrieve_cheapest_offer, fn _prefs -> nil end)

      @airfrance_repository
      |> expect(:retrieve_cheapest_offer, fn _prefs -> nil end)

      assert nil == @search.search(a_flight_preference())
    end

    test "returns empty when all airlines raises error" do
      @british_repository
      |> expect(:retrieve_cheapest_offer, fn _prefs -> raise "Could not fetch" end)

      @airfrance_repository
      |> expect(:retrieve_cheapest_offer, fn _prefs -> raise "Could not fetch" end)

      assert nil == @search.search(a_flight_preference())
    end

    test "returns response from available airline" do
      preferences = a_flight_preference()
      british_offer = a_offer(price: 1111)

      @british_repository
      |> expect(:retrieve_cheapest_offer, fn ^preferences -> british_offer end)

      @airfrance_repository
      |> expect(:retrieve_cheapest_offer, fn ^preferences -> raise "Could not fetch" end)

      assert british_offer = @search.search(preferences)
    end
  end

  test "returns empty when all airlines return error response" do
    @british_repository
    |> expect(:retrieve_cheapest_offer, fn _prefs -> {:error, "Unknown reason"} end)

    @airfrance_repository
    |> expect(:retrieve_cheapest_offer, fn _prefs -> {:error, "Unknown reason"} end)

    assert nil == @search.search(a_flight_preference())
  end
end
