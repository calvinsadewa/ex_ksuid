defmodule ExKsuidTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest ExKsuid

  @epoch ExKsuid.epoch()

  test "Generate KSUID from example at https://github.com/segmentio/ksuid" do
    test_data = [
      {107_611_700, "9850EEEC191BF4FF26F99315CE43B0C8", "0uk1Hbc9dQ9pxyTqJ93IUrfhdGq"},
      {107_611_700, "CC55072555316F45B8CA2D2979D3ED0A", "0uk1HdCJ6hUZKDgcxhpJwUl5ZEI"},
      {107_611_700, "BA1C205D6177F0992D15EE606AE32238", "0uk1HcdvF0p8C20KtTfdRSB9XIm"},
      {107_611_700, "67517BA309EA62AE7991B27BB6F2FCAC", "0uk1Ha7hGJ1Q9Xbnkt0yZgNwg3g"}
    ]

    Enum.each(test_data, fn {timestamp, random, ksuid} ->
      assert ksuid ==
               ExKsuid.generate(
                 timestamp: timestamp + @epoch,
                 random_fn: fn -> Base.decode16!(random) end
               )
    end)
  end

  property "Generated Base62 KSUID have 27 character" do
    check all(int1 <- StreamData.positive_integer()) do
      assert 27 = String.length(ExKsuid.generate(timestamp: int1 + @epoch))
    end
  end

  property "Generated Raw KSUID have 20 Byte" do
    check all(int1 <- StreamData.positive_integer()) do
      assert 160 = bit_size(ExKsuid.generate_raw(timestamp: int1 + @epoch))
    end
  end

  property "Generated KSUID from earlier time lexicographically smaller than later time" do
    check all(int1 <- StreamData.positive_integer(), int2 <- StreamData.positive_integer()) do
      ExKsuid.generate(timestamp: int1 + @epoch) <
        ExKsuid.generate(timestamp: int1 + int2 + @epoch)
    end
  end

  property "Generate parse KSUID result in same time, and has 16 byte random payload" do
    check all(int1 <- StreamData.positive_integer()) do
      second = int1 + @epoch

      %{timestamp: timestamp, random_bytes: random_bytes} =
        ExKsuid.generate(timestamp: second) |> ExKsuid.parse()

      assert timestamp == second
      assert bit_size(random_bytes) == 128
    end
  end
end
