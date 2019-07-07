import Config

alias OfferService.Infrastructure.{AirFrance, BritishAirlines}

config :offer_service, :airline_repositories, [
  AirFrance.AirlineSoapRepository,
  BritishAirlines.AirlineSoapRepository
]
