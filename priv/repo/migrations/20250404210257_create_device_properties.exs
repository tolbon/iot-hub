defmodule IotHub.Repo.Migrations.CreateDeviceProperties do
  use Ecto.Migration

  def change do
    create table(:device_properties, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :key, :string
      add :value_type, :string
      add :string_value, :string
      add :number_value, :float
      add :device_id, references(:devices, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:device_properties, [:device_id])
  end
end
