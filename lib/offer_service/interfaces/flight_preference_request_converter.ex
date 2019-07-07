defmodule OfferService.Interfaces.FlightPreferenceRequestConverter do
  alias OfferService.Domain.FlightPreferences

  def convert(conn = %Plug.Conn{}) do
    conn
    |> Map.get(:params)
    |> to_domain()
    |> case do
      error = {:error, _reason} -> error
      preferences -> {:ok, preferences}
    end
  end

  defp to_domain(%{"origin" => origin, "destination" => destination, "departureDate" => date}) do
    FlightPreferences.new(origin: origin, destination: destination, departure_date: date)
  end

  defp to_domain(params) when is_map(params) do
    missing =
      ["origin", "destination", "departureDate"]
      |> Stream.filter(fn property -> not Map.has_key?(params, property) end)
      |> Enum.join(", ")

    {:error, "Missing query parameter: #{missing}"}
  end
end
