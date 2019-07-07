# ASSUMPTIONS

## About the data
According to my research, both Airline APIs lists the offers sorted by lowest to highest price. For this reason, I am avoided parsing the entire XML file to ensure that the price is the lowest. This is only valid for our case: adult, one-way flights.

I am assuming that in the future this may change, but to keep it simple and fast, I decided to do the above strategy.
