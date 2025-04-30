defmodule IotHub.Devices.DevicePropertyHistory do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "device_properties_histories" do
    field :emission_at, :utc_datetime_usec
    field :device_id, :binary_id
    field :key, :string
    field :number_value, :float
    field :value_type, :string
    field :string_value, :string

    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc false
  def changeset(device_property_history, attrs) do
    device_property_history
    |> cast(attrs, [:emission_at, :key, :value_type, :string_value, :number_value])
    |> validate_required([:emission_at, :key, :value_type, :string_value, :number_value])
  end
end
