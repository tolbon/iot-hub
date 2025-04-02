defmodule IotHub.Repo.Migrations.CreateHubs do
  use Ecto.Migration

  def change do
    create table(:hubs) do
      add :enabled, :boolean, default: false, null: false
      add :name, :string
      add :broker_url, :string

      timestamps(type: :utc_datetime)
    end
  end
end
