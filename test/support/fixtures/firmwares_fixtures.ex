defmodule IotHub.FirmwaresFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `IotHub.Firmwares` context.
  """

  @doc """
  Generate a firmware.
  """
  def firmware_fixture(attrs \\ %{}) do
    {:ok, firmware} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> IotHub.Firmwares.create_firmware()

    firmware
  end
end
