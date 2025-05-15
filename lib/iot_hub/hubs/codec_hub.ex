defmodule IotHub.Hubs.CodecHub do
  use Ecto.Schema
  import Ecto.Changeset

  schema "codecs_hubs" do
    field :hub_id, :binary_id
    field :codec_id, :binary_id
    field :is_internal, :boolean, default: false
    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc false
  def changeset(codec_hub, attrs) do
    codec_hub
    |> cast(attrs, [])
    |> validate_required([])
  end
end
