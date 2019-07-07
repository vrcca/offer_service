# Offer Service

**Fetches cheap flights directly from Airlines.**

Assumptions about this project can be found at [ASSUMPTIONS.md](ASSUMPTIONS.md).

## Installation
Optionally, you can [run the application with Docker](#running-the-app-with-docker).
1. Install Erlang 20.0 or later
2. Install Elixir 1.9+
3. Run `make`

## Running the tests
In the root folder, run `make test` _(Requires Docker)_

## Running the app locally
You need to provide the API keys for both British Airlines and Air France webservices.

Run `BA_API_KEY="british_key" AF_API_KEY="air_france_key" make start`

## Running the app with Docker
1. Install Docker
2. Run `make docker-image`
3. Run `make start-with-docker`

Also, you can pass the port when starting with docker:
`PORT=4001 make start-with-docker`

## Endpoints

### Find Cheapest Offer
 Returns the Airline and price of the cheapest offer at the given date and route.
 
Endpoint: 
`GET /findCheapestOffer`

Required query parameters:
`origin`: The airport code of origin.
`destination`: The airport code of destination.
`departureDate`: The departure date with format *yyyy-mm-dd*
