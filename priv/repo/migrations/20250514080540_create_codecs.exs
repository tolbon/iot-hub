defmodule IotHub.Repo.Migrations.CreateCodecs do
  use Ecto.Migration

  def change do
    create table(:codecs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :source, :string, null: false
      add :code_or_path, :binary

      timestamps(type: :utc_datetime)
      add :deleted_at, :utc_datetime
    end
  end
end
