defmodule IotHub.Hubs.Hub do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "hubs" do
    field :enabled, :boolean, default: false
    field :name, :string
    field :broker_url, :string
    # Associations
    many_to_many :users, IotHub.Accounts.User, join_through: IotHub.Hubs.UserHub
    has_many :device_models, IotHub.Devices.DeviceModel
    has_many :devices, IotHub.Devices.Device
    has_many :firmwares, IotHub.Firmwares.Firmware
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(hub, attrs) do
    hub
    |> cast(attrs, [:enabled, :name, :broker_url])
    |> validate_required([:enabled, :name, :broker_url])
  end
end
