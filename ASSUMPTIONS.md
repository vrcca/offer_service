# ASSUMPTIONS

## The architecture

I applied the hexagonal architecture principles. I kept all the glue code out of the `application` and `domain`, so I could focus on the business logic first. I also tried to use airline specific terms in order to make it easy to grasp and reason about.

### Application
Here are located the use cases of the app (which is just 1 for now). This should be heavily tested.

### Domain
You can find domain-specific logic. For now, I only created the repositories and the domain models. This should be also heavily covered by tests.

### Infrastructure
Keeps all the "glue code" necessary for it to run. It connects the app to the external services. Tests in here are usually integration tests. You will notice [airline-specific code](#airline-specific-code) here.

### Interfaces
The entry points of the app. In here, I left the parsing logic to keep it closer to the code that uses it. Tests in this folder are mostly integration tests.

Modules in here are great candidates to be moved to `infrastructure` as well.

### Airline-specific code

1. I deliberately left the Airline's SOAP repositories with duplicated code. This is to avoid needless abstractions and increasing complexity. I believe that, as it is now, it is pretty easy to read, maintain and evolve.

2. I think that the Airline specific code can be made into separate applications. However, I did not want to make it more complex than it needs to be, so I left them in the same repo.

## About the data
1. According to my research, both Airline APIs lists the offers sorted by lowest to highest price. For this reason, I am avoided parsing the entire XML file to ensure that the price is the lowest. This is only valid for our case: adult, one-way flights.

I am assuming that in the future this may change, but to keep it simple and fast, I decided to do the above strategy.

## Future optimizations

1. If my assumptions about the data above are correct, I believe we should stream the response from the webservices in order to avoid downloading the entire payload just to get the first offer. Another option is to send the response to another process in order to traverse it to find the cheapest offer.

2. The webservices have load constraints. Some form of backpressure will be needed, however I left it off to keep the solution simple.

3. I did not reasearch about the errors that each airline can return from requests. For instance, an empty response is always returned for any invalid XML response, server validations, api key expiration, api rate limit reached, and other non successful response. Therefore, these were left out from scope. However, they should be handled properly.

4. The endpoint `GET /findCheapestOffer` does not follow REST practices. We should migrate it to a `POST /offers/search`, for the results may change from time to time.

## Processes

1. The router should be able to handle at least 100 concurrent connections. 

2. The use case processes requests concurrently. However, errors do not propagate to parent process for it is not linked to the task processes.

3. I used `HTTPoison` to make the requests to the airline APIs. It uses hackney to do the real requests which keep a connection pool to try to optimize the requests.

4. `Task.Supervisor` was used to issue async requests to the repository. It is important to notice that the max concurrency enabled by this is the total of schedulers of the VM.

## Deployment

1. We can use Kubernetes to deploy our app. For this, we can build and deploy the docker image to a docker hub then use it.
2. The configuration needs to be provided at runtime. See [README.md](README.md) about the requirements.
3. There is no health check endpoint for now. We can issue a request to the endpoint to ensure it is fully functional.
4. It needs no service discovery for now. This may change in the future.
5. Logs can be captured from the standard output.
