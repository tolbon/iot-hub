defmodule IotHub.Repo.Migrations.CreateCodecsHubs do
  use Ecto.Migration

  def change do
    create table(:codecs_hubs) do
      add :hub_id, references(:hubs, on_delete: :nothing, type: :binary_id)
      add :codec_id, references(:codecs, on_delete: :nothing, type: :binary_id)
      add :is_internal, :boolean, default: false, null: false

      timestamps(type: :utc_datetime, updated_at: false)
      add :deleted_at, :utc_datetime

    end

    create index(:codecs_hubs, [:hub_id])
    create index(:codecs_hubs, [:codec_id])
  end
end
