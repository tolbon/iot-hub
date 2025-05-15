defmodule IotHub.Codecs.Codec do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "codecs" do
    field :name, :string
    field :source, Ecto.Enum, values: [:wasm_inline, :s3, :builtin]
    field :code_or_path, :binary

    timestamps(type: :utc_datetime)
    field :deleted_at, :utc_datetime

  end

  @doc false
  def changeset(codec, attrs) do
    codec
    |> cast(attrs, [:name, :source, :code_or_path])
    |> validate_required([:name, :source, :code_or_path])
  end
end
