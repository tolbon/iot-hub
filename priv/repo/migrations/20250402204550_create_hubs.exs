defmodule IotHub.Repo.Migrations.CreateHubs do
  use Ecto.Migration

  def change do
    create table(:hubs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :enabled, :boolean, default: false, null: false
      add :name, :string
      add :broker_url, :string

      timestamps(type: :utc_datetime)
    end
  end
end
