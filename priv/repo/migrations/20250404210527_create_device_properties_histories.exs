defmodule IotHub.Repo.Migrations.CreateDevicePropertiesHistories do
  use Ecto.Migration

  def change do
    create table(:device_properties_histories, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :emission_at, :utc_datetime_usec
      add :key, :string
      add :value_type, :string
      add :string_value, :string
      add :number_value, :float
      add :device_id, references(:devices, on_delete: :nothing, type: :binary_id)

      timestamps(type: :utc_datetime)
    end

    create index(:device_properties_histories, [:device_id])
    create unique_index(:device_properties_histories, [:device_id, :key, :emission_at])
    execute "SELECT create_hypertable('device_properties_histories', by_range('emission_at'), if_not_exists => TRUE);"
  end
end
