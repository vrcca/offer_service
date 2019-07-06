defmodule OfferService.Interfaces.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  alias OfferService.Interfaces.Router

  @opts Router.init([])

  test "returns 404 for unknown routes" do
    conn = conn(:get, "/unknown-route")
    conn = Router.call(conn, @opts)
    assert conn.status == 404
  end
end
