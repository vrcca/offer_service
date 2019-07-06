defmodule OfferService.Domain.AirlineRepository do
  alias OfferService.Domain.{FlightPreferences, Offer}
  @callback retrieve_cheapest_offer(%FlightPreferences{}) :: %Offer{}
end
