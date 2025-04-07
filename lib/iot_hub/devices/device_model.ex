defmodule IotHub.Devices.DeviceModel do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "device_models" do
    field :name, :string
    field :version, :string
    field :schema, :map
    field :hub_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(device_model, attrs) do
    device_model
    |> cast(attrs, [:name, :version, :schema])
    |> validate_required([:name, :version])
  end
end
