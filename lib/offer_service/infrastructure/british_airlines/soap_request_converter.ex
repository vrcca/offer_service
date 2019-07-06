defmodule OfferService.Infrastructure.BritishAirlines.SoapRequestConverter do
  require EEx
  alias OfferService.Domain.FlightPreferences

  @template_file __DIR__ <> "/request_template.eex"

  EEx.function_from_file(
    :def,
    :convert_with_template,
    @template_file,
    [:assigns],
    trim: true
  )

  def convert(preferences = %FlightPreferences{}) do
    preferences
    |> Map.from_struct()
    |> convert_with_template()
  end
end
