defmodule OfferService.Interfaces.ResponseContentTypePlug do
  import Plug.Conn

  def init(opts = [type: _type]) do
    opts
  end

  def call(conn, type: type) do
    conn
    |> put_resp_content_type(type)
  end
end
