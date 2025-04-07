defmodule IotHub.Repo.Migrations.CreateFirmwares do
  use Ecto.Migration

  def change do
    create table(:firmwares, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :hub_id, references(:hubs, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:firmwares, [:hub_id])
  end
end
