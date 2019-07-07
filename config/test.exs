import Config

config :offer_service, :airline_repositories, [
  OfferService.Infrastructure.AirFranceMockRepository,
  OfferService.Infrastructure.BritishAirlinesMockRepository
]

config :offer_service, british_airlines_api_key: "sandbox"
config :offer_service, british_airlines_api_url: "http://localhost:7777"

config :offer_service, air_france_api_key: "sandbox"
config :offer_service, air_france_api_url: "http://localhost:8888"
