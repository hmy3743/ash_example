defmodule Cona.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      version: "0.1.0",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      releases: releases()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    []
  end

  defp aliases do
    [
      reset: [
        "ash_postgres.drop --force-drop",
        "ash_postgres.create",
        "ash_postgres.migrate",
        "run -e Core.Account.Seed.run",
        "run -e Core.Review.Seed.run",
        "run -e Core.Classification.Seed.run"
      ]
    ]
  end

  defp releases do
    [
      graphql: [
        applications: [graphql_web: :permanent],
        include_executables_for: [:unix]
      ]
    ]
  end
end
