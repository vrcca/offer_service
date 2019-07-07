import Config

alias OfferService.Infrastructure.{AirFrance, BritishAirlines}

config :offer_service, :airline_repositories, [
  AirFrance.AirlineSoapRepository,
  BritishAirlines.AirlineSoapRepository
]

config :offer_service, british_airlines_api_key: System.fetch_env!("BA_API_KEY")
config :offer_service, british_airlines_api_url: System.fetch_env!("BA_API_URL")

config :offer_service, air_france_api_key: System.fetch_env!("AF_API_KEY")
config :offer_service, air_france_api_url: System.fetch_env!("AF_API_URL")
