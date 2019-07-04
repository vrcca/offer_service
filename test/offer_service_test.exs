defmodule OfferServiceTest do
  use ExUnit.Case
  doctest OfferService

  test "greets the world" do
    assert OfferService.hello() == :world
  end
end
