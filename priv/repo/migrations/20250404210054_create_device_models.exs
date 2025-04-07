defmodule IotHub.Repo.Migrations.CreateDeviceModels do
  use Ecto.Migration

  def change do
    create table(:device_models, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :version, :string
      add :schema, :map
      add :hub_id, references(:hubs, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:device_models, [:hub_id])
  end
end
