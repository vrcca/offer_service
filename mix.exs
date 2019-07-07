defmodule OfferService.MixProject do
  use Mix.Project

  def project do
    [
      app: :offer_service,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  defp elixirc_paths(env) when env in [:test, :integration], do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      extra_applications: [:logger],
      mod: {OfferService.Application, [Mix.env()]}
    ]
  end

  defp deps do
    [
      {:mox, "~> 0.5", only: [:test, :integration]},
      {:plug_cowboy, "~> 2.1"},
      {:httpoison, "~> 1.4"},
      {:sweet_xml, "~> 0.6"},
      {:jason, "~> 1.1"}
    ]
  end
end
