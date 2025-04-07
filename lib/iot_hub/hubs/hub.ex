defmodule IotHub.Hubs.Hub do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "hubs" do
    field :enabled, :boolean, default: false
    field :name, :string
    field :broker_url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(hub, attrs) do
    hub
    |> cast(attrs, [:enabled, :name, :broker_url])
    |> validate_required([:enabled, :name, :broker_url])
  end
end
