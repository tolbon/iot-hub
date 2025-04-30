defmodule IotHub.Hubs.UserHub do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key false
  @foreign_key_type :binary_id
  schema "users_hubs" do
    belongs_to(:user, IotHub.Accounts.User)
    belongs_to(:hub, IotHub.Hubs.Hub)
    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user_hub, attrs) do
    user_hub
    |> cast(attrs, [])
    |> validate_required([])
  end
end
