defmodule ExKsuid do
  @moduledoc """
  Module for KSUID (K-Sortable ID)

  KSUID is a identifier which consist 4 byte of timestamp data + 16 byte of random data.
  usually represented in base62 string, which can be lexicographically sorted for rough time ordering

  KSUID in raw form has 20 byte of data, 27 byte in base62 format
  """

  alias ExKsuid.Base62

  # Epoch timestamp used in KSUID
  @epoch 1_400_000_000

  @typedoc """
  Option for generating KSUID
  timestamp is epoch timestamp in second
  random_fn is custom random function used, need to return 16 byte of random data
  """
  @type generate_opt :: [
          timestamp: integer(),
          random_fn: (() -> binary())
        ]

  @type raw_ksuid :: <<_::160>>
  @type random_payload :: <<_::128>>

  @doc """
  Generate a new KSUID in Base62 form,
  there is option to generate ksuid from existing timestamp

  ## Examples

      iex> ExKsuid.generate([timestamp: 1507611700, random_fn: fn -> Base.decode16!("9850EEEC191BF4FF26F99315CE43B0C8") end])
      "0uk1Hbc9dQ9pxyTqJ93IUrfhdGq"
  """
  @spec generate(generate_opt()) :: Base62.t()
  def generate(opt \\ []) do
    Base62.encode(generate_raw(opt))
    |> String.pad_leading(27, "0")
  end

  @doc """
    Generate a new KSUID in raw form,
    there is option to generate ksuid from existing timestamp

  ## Examples

      iex> ExKsuid.generate_raw([timestamp: 1507611700, random_fn: fn -> Base.decode16!("9850EEEC191BF4FF26F99315CE43B0C8") end])
      <<107611700::32>> <> Base.decode16!("9850EEEC191BF4FF26F99315CE43B0C8")
  """
  @spec generate_raw(generate_opt()) :: raw_ksuid()
  def generate_raw(opt \\ []) do
    timestamp = opt[:timestamp] || System.system_time(:second)
    timestamp = timestamp - @epoch
    # assert timestamp > epoch used
    true = timestamp > 0

    timestamp_bytes = <<timestamp::32>>

    random_bytes =
      if is_nil(opt[:random_fn]), do: :crypto.strong_rand_bytes(16), else: opt[:random_fn].()

    # assert 16 byte of random data
    128 = bit_size(random_bytes)

    timestamp_bytes <> random_bytes
  end

  @typedoc """
  timestamp epoch in second
  random_bytes random payload carried by ksuid
  """
  @type parse_result :: %{
          timestamp: pos_integer(),
          random_bytes: random_payload
        }

  @doc """
  Parse a base62 Ksuid to it's timestamp and random payload

  ## Examples

      iex> ExKsuid.parse("0uk1Hbc9dQ9pxyTqJ93IUrfhdGq")
      %{timestamp: 1507611700, random_bytes: Base.decode16!("9850EEEC191BF4FF26F99315CE43B0C8")}

  """
  @spec parse(Base62.t()) :: parse_result()
  def parse(base62_ksuid) do
    raw_byte = Base62.decode(base62_ksuid)
    bitsize = bit_size(raw_byte)
    true = bitsize <= 160
    padding = 160 - bitsize
    raw_byte = <<0::size(padding)>> <> raw_byte
    parse_raw(raw_byte)
  end

  @doc """
  Parse a raw Ksuid to it's timestamp and random payload

  ## Examples

    iex> ExKsuid.parse_raw(<<107611700::32>> <> Base.decode16!("9850EEEC191BF4FF26F99315CE43B0C8"))
    %{timestamp: 1507611700, random_bytes: Base.decode16!("9850EEEC191BF4FF26F99315CE43B0C8")}
  """
  @spec parse_raw(raw_ksuid()) :: parse_result()
  def parse_raw(raw_ksuid) do
    <<timestamp_skewed::32, random_bytes::binary-size(16)>> = raw_ksuid

    %{
      timestamp: timestamp_skewed + @epoch,
      random_bytes: random_bytes
    }
  end
end
