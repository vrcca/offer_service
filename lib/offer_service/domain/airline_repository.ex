defmodule OfferService.Domain.AirlineRepository do
  alias OfferService.Domain.{FlightPreferences, Offer}
  @callback search_offers(%FlightPreferences{}) :: [%Offer{}]
end
