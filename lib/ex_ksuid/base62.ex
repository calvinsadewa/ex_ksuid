defmodule ExKsuid.Base62 do
  @moduledoc "Module to encode/decode byte representation to Base62 representation"

  # Char legitimate in base62 encoding
  @base62_chars String.codepoints(
                  "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
                )

  # Helper caching for transforming base62 char to int or vice versa
  @char_to_int @base62_chars |> Enum.with_index() |> Enum.into(%{})
  @int_to_char @char_to_int |> Enum.into(%{}, fn {c, i} -> {i, c} end)

  @type t :: String.t()

  @doc """
  Encode bytes into base62

  ## Examples

      iex> encode("Hello world!")
      "T8dgcjRGuYUueWht"
  """
  @spec encode(binary()) :: t
  def encode(bytes) when is_binary(bytes) do
    bytes
    |> :erlang.binary_to_list()
    |> Integer.undigits(256)
    |> Integer.digits(62)
    |> Enum.map(&@int_to_char[&1])
    |> List.to_string()
  end

  @doc """
  Decode base62 string to bytes

  ## Examples

      iex> decode("T8dgcjRGuYUueWht")
      "Hello world!"
  """
  @spec decode(t) :: binary()
  def decode(base62) when is_binary(base62) do
    base62
    |> String.codepoints()
    |> Enum.map(&@char_to_int[&1])
    |> Integer.undigits(62)
    |> Integer.digits(256)
    |> :erlang.list_to_binary()
  end
end
