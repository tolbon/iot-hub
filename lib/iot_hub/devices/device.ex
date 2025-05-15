defmodule IotHub.Devices.Device do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "devices" do
    field :name, :string
    field :physical_id, :string
    field :last_seen_at, :utc_datetime, default: ~U[1970-01-01 00:00:00Z]
    field :hub_id, :binary_id
    belongs_to :firmware, IotHub.Firmwares.Firmware

    timestamps(type: :utc_datetime)
    field :deleted_at, :utc_datetime
  end

  @doc false
  def changeset(device, attrs) do
    device
    |> cast(attrs, [:name, :last_seen_at])
    |> validate_required([:name, :last_seen_at])
  end

end
