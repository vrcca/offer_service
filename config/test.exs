import Config

config :offer_service, :airline_repositories, [
  OfferService.Infrastructure.AirFranceMockRepository,
  OfferService.Infrastructure.BritishAirlinesMockRepository
]
