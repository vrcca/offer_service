PORT?=4001

.PHONY: build, dependencies, start, unit-test, integration-test, start-dependencies, stop-dependencies, test

build: dependencies
	mix compile

dependencies:
	printf 'Y'  | mix local.hex --if-missing && \
	printf 'nn' | mix local.rebar  && \
	mix deps.get

start:
	PORT=$(PORT) mix run --no-halt

test:
	mix format --check-formatted && \
	$(MAKE) start-dependencies && \
	mix test --include integration && \
	$(MAKE) stop-dependencies

unit-test:
	mix test --exclude integration

integration-test:
	mix test --only integration

start-dependencies:
	docker-compose up -d

stop-dependencies:
	docker-compose down
