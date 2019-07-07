defmodule OfferService.Interfaces.RouterTest do
  use ExUnit.Case, async: true
  use Plug.Test

  import Support.Fixtures

  alias OfferService.Interfaces.Router

  @opts Router.init([])

  @tag :integration
  test "returns 404 for unknown routes" do
    conn = conn(:get, "/unknown-route")
    conn = Router.call(conn, @opts)
    assert conn.status == 404
  end

  @tag :integration
  test "returns cheapest offer data" do
    conn = a_cheap_offer_request(origin: "MUC", destination: "LHR", departureDate: "2019-09-28")

    conn = Router.call(conn, @opts)

    expected_response = %{"data" => %{"cheapestOffer" => %{"amount" => 94.14, "airline" => "BA"}}}
    assert conn.status == 200
    assert Jason.decode!(conn.resp_body) == expected_response

    [content_type] = get_resp_header(conn, "content-type")
    assert content_type =~ "application/json"
  end

  @tag :integration
  test "returns error when missing properties" do
    conn =
      a_cheap_offer_request(
        missing_origin: "MUC",
        missing_destination: "LHR",
        wrong_departure: "2019-09-28"
      )

    conn = Router.call(conn, @opts)

    expected_response = %{
      "error" => "Missing query parameter: origin, destination, departureDate"
    }

    assert conn.status == 400
    assert Jason.decode!(conn.resp_body) == expected_response
    [content_type] = get_resp_header(conn, "content-type")
    assert content_type =~ "application/json"
  end

  @tag :integration
  test "returns empty response when there is no data" do
    conn =
      a_cheap_offer_request(
        origin: "BER",
        destination: "LHR",
        departureDate: "2001-09-28"
      )

    conn = Router.call(conn, @opts)

    expected_response = %{"data" => %{"cheapestOffer" => nil}}

    assert conn.status == 200
    assert Jason.decode!(conn.resp_body) == expected_response
  end
end
