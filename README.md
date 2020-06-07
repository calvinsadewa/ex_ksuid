# ExKsuid

[![Hex pm](http://img.shields.io/hexpm/v/ex_ksuid.svg?style=flat)](https://hex.pm/packages/ex_ksuid)
[![Build Status](https://github.com/calvinsadewa/ex_ksuid/workflows/Elixir%20CI/badge.svg)](https://github.com/calvinsadewa/ex_ksuid/actions)

Fully featured KSUID module in Elixir

KSUID (K-Sortable unique ID) is a way to generate ID (like to UUID), which use 4 byte of timestamp and 16 byte of random data. \
KSUID can be lexicographically sort for rough ordering (at second resolution) of when KSUID is generated, in DB, sorting by KSUID as primary key usually faster than sorting `inserted_at` or `updated_at`

Example:
>Example (KSUID in Base62)
1czONudbZwh5siu2igQJY94QkFH

This module can:
- Generate KSUID in Base62/Raw byte format, with specific input on timestamp & random payload 
- Parse KSUID to get it's timestamp part and random payload part
- Provide Ecto Schema basic Type for use as field/primary key, either in Base62 or Raw byte

more information on https://github.com/segmentio/ksuid

## Common Usage
```
# Generate KSUID (simple)
ExKsuid.generate()
## 1czONudbZwh5siu2igQJY94QkFH

# Parse information in KSUID
result = ExKsuid.parse("1czONudbZwh5siu2igQJY94QkFH")
## %{
##   random_bytes: <<78, 137, 74, 76, 6, 99, 179, 98, 179, 99, 109, 200, 247, 175,
##     171, 187>>,
##   timestamp: 1591527918
## }
DateTime.from_unix(result.timestamp)
## {:ok, ~U[2020-06-07 11:05:18Z]}

# Filter all KSUID after 2020-02-15 timestamp
data = [~U[2020-01-01 00:00:00Z], ~U[2020-02-01 00:00:00Z], ~U[2020-03-01 00:00:00Z], ~U[2020-04-01 00:00:00Z], ~U[2020-05-01 00:00:00Z]]
data = data |> Enum.map(& ExKsuid.generate(timestamp: &1 |> DateTime.to_unix()))
## ["1Vlny8xRAj9lht9c0DsxpbBK8Gi", "1XBMnOgQG7Gm7S63kPjiW0EqIlM",
## "1YVHNQAFJsvQgtQvcLlpdeW1FCY", "1ZuqCjUj9tluPXTyU2q45w3ZwiW",
## "1bHZuH1adLPe8PjgHwYz7JPHVHx"]
ksuid = ExKsuid.generate(timestamp: ~U[2020-02-15 00:00:00Z] |> DateTime.to_unix())
## 1XouWeBxLmlTwhaLqOu4a7SPLp7
data |> Enum.filter(fn d -> d > ksuid end) |> Enum.map(fn d -> 
  result = ExKsuid.parse(d)
  DateTime.from_unix!(result.timestamp)
end)
## [~U[2020-03-01 00:00:00Z], ~U[2020-04-01 00:00:00Z], ~U[2020-05-01 00:00:00Z]]

# Use in Ecto Schema
defmodule Account do
  use Ecto.Schema

  @primary_key {:ksuid, ExKsuid.EctoType, autogenerate: true}
  schema "account" do
    field :name, :string
    field :email, :string
  end
end
```

## Comparison
[elixir-ksuid](https://github.com/girishramnani/elixir-ksuid) is established module for generating KSUID in elixir

`ExKsuid` get inspiration from `elixir-ksuid`. In comparison, ExKsuid has several advantage like:
- Generate KSUID based on timestamp & custom random source
- Generate Raw byte KSUID, which is smaller (20 byte) than usual base62 format (27 byte)



## Installation

The package can be installed
by adding `ex_ksuid` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ex_ksuid, "~> 0.2.0"}
  ]
end
```
