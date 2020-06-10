defmodule ExKsuid.MixProject do
  use Mix.Project

  def project do
    [
      app: :ex_ksuid,
      version: "0.2.1",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "ExKsuid",
      description: "Fully featured KSUID module in Elixir",
      source_url: "https://github.com/calvinsadewa/ex_ksuid",
      homepage_url: "https://github.com/calvinsadewa/ex_ksuid",
      package: [
        licenses: ["Apache-2.0"],
        links: %{"GitHub" => "https://github.com/calvinsadewa/ex_ksuid",},
      ],
      docs: [
        main: "readme", # The main page in the docs
        extras: ["README.md"]
      ]

    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.22", only: :dev, runtime: false},
      {:stream_data, "~> 0.5", only: :test},
      {:ecto, "~> 3.0", optional: true}
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end
end
