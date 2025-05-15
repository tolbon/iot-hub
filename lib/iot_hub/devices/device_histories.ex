defmodule IotHub.Devices.DeviceHistories do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "device_histories" do
    field :emission_at, :utc_datetime
    field :device_id, :binary_id
    field :type, Ecto.Enum, values: [:sys, :event, :action]
    field :trigger_name, :string
    field :data, :map
    field :metadata, :map

    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc false
  def changeset(device_histories, attrs) do
    device_histories
    |> cast(attrs, [:emission_at, :type, :data])
    |> validate_required([:emission_at, :type])
  end
end
