defmodule IotHub.DevicesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `IotHub.Devices` context.
  """

  @doc """
  Generate a device.
  """
  def device_fixture(attrs \\ %{}) do
    {:ok, device} =
      attrs
      |> Enum.into(%{
        last_seen_at: ~U[2025-04-03 20:54:00Z],
        name: "some name"
      })
      |> IotHub.Devices.create_device()

    device
  end

  @doc """
  Generate a device_model.
  """
  def device_model_fixture(attrs \\ %{}) do
    {:ok, device_model} =
      attrs
      |> Enum.into(%{
        name: "some name",
        schema: %{},
        version: "some version"
      })
      |> IotHub.Devices.create_device_model()

    device_model
  end

  @doc """
  Generate a device_property.
  """
  def device_property_fixture(attrs \\ %{}) do
    {:ok, device_property} =
      attrs
      |> Enum.into(%{
        key: "some key",
        number_value: 120.5,
        string_value: "some string_value",
        value_type: "some value_type"
      })
      |> IotHub.Devices.create_device_property()

    device_property
  end

  @doc """
  Generate a device_property_history.
  """
  def device_property_history_fixture(attrs \\ %{}) do
    {:ok, device_property_history} =
      attrs
      |> Enum.into(%{
        emission_at: ~U[2025-04-03 21:05:00.000000Z],
        key: "some key",
        number_value: 120.5,
        string_value: "some string_value",
        value_type: "some value_type"
      })
      |> IotHub.Devices.create_device_property_history()

    device_property_history
  end
end
