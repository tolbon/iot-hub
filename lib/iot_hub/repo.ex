defmodule IotHub.Repo do
  use Ecto.Repo,
    otp_app: :iot_hub,
    adapter: Ecto.Adapters.Postgres
end
