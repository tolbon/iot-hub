defmodule IotHub.Repo.Migrations.AddSoftDelete do
  use Ecto.Migration

  def change do
    alter table(:hubs) do
      add :deleted_at, :utc_datetime
    end

    alter table(:devices) do
      add :deleted_at, :utc_datetime
    end

    alter table(:firmwares) do
      add :deleted_at, :utc_datetime
    end

    alter table(:device_models) do
      add :deleted_at, :utc_datetime
    end
  end
end
