defmodule OfferService.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    port = retrieve_port()

    children = [
      {Plug.Cowboy, scheme: :http, plug: OfferService.Interfaces.Router, options: [port: port]},
      {Task.Supervisor, name: OfferService.AirlineTaskSupervisor}
    ]

    opts = [strategy: :one_for_one, name: OfferService.Supervisor]

    with result = {:ok, _pid} <- Supervisor.start_link(children, opts) do
      IO.puts("\nServer running on port #{port}\n")
      result
    end
  end

  defp retrieve_port() do
    System.get_env("PORT", "4001")
    |> String.to_integer()
  end
end
