defmodule ExKsuid.Base62Test do
  use ExUnit.Case
  use ExUnitProperties
  alias ExKsuid.Base62

  test "encode Hello world!" do
    assert "T8dgcjRGuYUueWht" == Base62.encode("Hello world!")
  end

  test "encode <<0, 15, 65, 70, 79, 146, 111, 125, 58, 62, 136, 209, 151, 190, 6>>" do
    assert "1ggI0aYsuOXLPipUZKY" ==
             Base62.encode(<<0, 15, 65, 70, 79, 146, 111, 125, 58, 62, 136, 209, 151, 190, 6>>)
  end

  property "encode and decode binary data return same binary data" do
    check all(data <- StreamData.binary()) do
      x = :binary.decode_unsigned(data)
      y = :binary.decode_unsigned(Base62.decode(Base62.encode(data)))
      assert x == y
    end
  end
end
