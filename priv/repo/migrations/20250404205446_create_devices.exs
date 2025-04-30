defmodule IotHub.Repo.Migrations.CreateDevices do
  use Ecto.Migration

  def change do
    create table(:devices, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :last_seen_at, :utc_datetime, default: ~U[1970-01-01 00:00:00Z]
      add :hub_id, references(:hubs, on_delete: :nothing, type: :binary_id)
      add :firmware_id, references(:firmwares, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:devices, [:hub_id])
    create index(:devices, [:firmware_id])
  end
end
