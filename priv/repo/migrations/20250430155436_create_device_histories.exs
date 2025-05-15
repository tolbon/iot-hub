defmodule IotHub.Repo.Migrations.CreateDeviceHistories do
  use Ecto.Migration

  def change do
    create table(:device_histories, primary_key: false) do
      add :emission_at, :utc_datetime
      add :device_id, references(:devices, on_delete: :nothing, type: :binary_id)
      add :type, :string
      add :trigger_name, :string # event name or action name
      add :data, :map
      add :metadata, :map

      timestamps(type: :utc_datetime)
    end

    create index(:device_histories, [:device_id])
    create unique_index(:device_histories, [:device_id, :emission_at])
    execute "SELECT create_hypertable('device_histories', by_range('emission_at'), if_not_exists => TRUE);"
  end
end
