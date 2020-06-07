defmodule ExKsuid.EctoTypeTest do
  use ExUnit.Case
  use ExUnitProperties

  describe "ExKsuid.EctoType" do
    property "Cast & Load return same data" do
      check all(data <- StreamData.binary()) do
        {:ok, casted} = ExKsuid.EctoType.cast(data)
        assert {:ok, data} == ExKsuid.EctoType.load(casted)
        assert {:ok, data} == ExKsuid.EctoType.dump(data)
      end
    end

    property "Generate Base62 KSUID" do
      check all(_data <- StreamData.binary()) do
        assert 27 == String.length(ExKsuid.EctoType.autogenerate())
      end
    end
  end

  describe "ExKsuid.EctoTypeRaw" do
    property "Cast & Load return same data" do
      check all(data <- StreamData.binary()) do
        {:ok, casted} = ExKsuid.EctoTypeRaw.cast(data)
        assert {:ok, data} == ExKsuid.EctoTypeRaw.load(casted)
        assert {:ok, data} == ExKsuid.EctoTypeRaw.dump(data)
      end
    end

    property "Generate Raw KSUID" do
      check all(_data <- StreamData.binary()) do
        assert 160 == bit_size(ExKsuid.EctoTypeRaw.autogenerate())
      end
    end
  end
end
