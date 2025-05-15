defmodule IotHub.Firmwares.Firmware do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "firmwares" do
    field :name, :string
    field :hub_id, :binary_id
    belongs_to :device_model, IotHub.Devices.DeviceModel
    belongs_to :sys_model, IotHub.Devices.DeviceModel

    timestamps(type: :utc_datetime)
    field :deleted_at, :utc_datetime
  end

  @doc false
  def changeset(firmware, attrs) do
    firmware
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
