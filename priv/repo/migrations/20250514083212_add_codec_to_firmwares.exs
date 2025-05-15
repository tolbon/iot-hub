defmodule IotHub.Repo.Migrations.AddCodecToFirmwares do
  use Ecto.Migration

  def change do
    alter table(:firmwares) do
      add :sys_model_id, references(:device_models, type: :binary_id, on_delete: :nothing)
    end

    alter table(:device_models) do
      add :is_internal, :boolean, default: false
      add :hub_codec_id, references(:codecs_hubs, on_delete: :nothing)
    end
  end
end
