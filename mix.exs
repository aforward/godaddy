defmodule Godaddy.Mixfile do
  use Mix.Project

  @name    :godaddy
  @git_url "https://github.com/aforward/godaddy"
  @home_url @git_url
  @version "0.2.0"

  @deps [
    {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
    {:poison, "~> 3.1.0"},
    {:httpoison, "~> 0.11.1"},
    {:ex_doc, ">= 0.0.0", only: :dev},
    {:fn_expr, "~> 0.1.0"},
  ]

  @aliases [
  ]


  @package [
    name: @name,
    files: ["lib", "mix.exs", "README*", "README*", "LICENSE*"],
    maintainers: ["Andrew Forward"],
    licenses: ["MIT"],
    links: %{"GitHub" => @git_url}
  ]

  # ------------------------------------------------------------

  def project do
    in_production = Mix.env == :prod
    [
      app:     @name,
      version: @version,
      elixir:  "~> 1.4",
      name: "Godaddy",
      description: "A minimal library for posting messages to the GoDaddy API.",
      package: @package,
      source_url: @git_url,
      homepage_url: @home_url,
      docs: [main: "Godaddy",
             extras: ["README.md"]],
      deps:    @deps,
      aliases: @aliases,
      build_embedded:  in_production,
    ]
  end

  def application do
    [
      mod: { Godaddy.Application, [] },
      extra_applications: [
        :logger
      ],
    ]
  end

end
