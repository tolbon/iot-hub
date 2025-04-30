defmodule IotHub.Repo.Migrations.CreateUsersHubs do
  use Ecto.Migration

  def change do
    create table(:users_hubs, primary_key: false) do
      add :user_id, references(:users, on_delete: :nothing, type: :binary_id), primary_key: true
      add :hub_id, references(:hubs, on_delete: :nothing, type: :binary_id), primary_key: true

      timestamps(type: :utc_datetime)
    end

    create index(:users_hubs, [:user_id])
    create index(:users_hubs, [:hub_id])
  end
end
