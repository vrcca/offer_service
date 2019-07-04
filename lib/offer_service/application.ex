defmodule OfferService.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    port = retrieve_port()

    children = [
      {Plug.Cowboy, scheme: :http, plug: OfferService.Interfaces.Router, options: [port: port]}
    ]

    opts = [strategy: :one_for_one, name: OfferService.Supervisor]

    with result = {:ok, _pid} <- Supervisor.start_link(children, opts) do
      IO.puts("Service running on port #{port}")
      result
    end
  end

  defp retrieve_port() do
    Application.get_env(:offer_service, :port, "4001")
    |> String.to_integer()
  end
end
