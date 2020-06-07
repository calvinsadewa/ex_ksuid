defmodule ExKsuid.EctoType do
  @moduledoc """
  Module for Base62 KSUID usage with ecto schema

  this EctoType can be used then like
  ```
  @primary_key {:ksuid, ExKsuid.EctoType, autogenerate: true}
  schema "account" do
    field :name, :string
    field :email, :string

    timestamps(type: :utc_datetime)
  end
  ```
  """
  use Ecto.Type

  def type, do: :string

  # cast ksuid can just be treated as string
  def cast(ksuid) when is_binary(ksuid) do
    {:ok, ksuid}
  end

  # Everything else is a failure though
  def cast(_), do: :error

  # Again, treat simply as string
  def load(ksuid_data) when is_binary(ksuid_data) do
    {:ok, ksuid_data}
  end

  # dump rule is same as cast
  def dump(ksuid), do: cast(ksuid)

  # Callback invoked by autogenerate fields.
  @doc false
  def autogenerate, do: ExKsuid.generate()
end

defmodule ExKsuid.EctoTypeRaw do
  @moduledoc """
  Module for Raw (20 bytes) KSUID usage with ecto schema

  this EctoType can be used then like
  ```
  @primary_key {:ksuid, ExKsuid.EctoTypeRaw, autogenerate: true}
  schema "account" do
    field :name, :string
    field :email, :string

    timestamps(type: :utc_datetime)
  end
  ```
  """
  use Ecto.Type

  def type, do: :binary_id

  # cast ksuid can just be treated as string
  def cast(ksuid) when is_binary(ksuid) do
    {:ok, ksuid}
  end

  # Everything else is a failure though
  def cast(_), do: :error

  # Again, treat simply as string
  def load(ksuid_data) when is_binary(ksuid_data) do
    {:ok, ksuid_data}
  end

  # dump rule is same as cast
  def dump(ksuid), do: cast(ksuid)

  # Callback invoked by autogenerate fields.
  @doc false
  def autogenerate, do: ExKsuid.generate_raw()
end
