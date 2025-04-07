defmodule IotHub.Devices.DeviceProperty do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "device_properties" do
    field :key, :string
    field :number_value, :float
    field :value_type, :string
    field :string_value, :string
    field :device_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(device_property, attrs) do
    device_property
    |> cast(attrs, [:key, :value_type, :string_value, :number_value])
    |> validate_required([:key, :value_type, :string_value, :number_value])
  end
end
