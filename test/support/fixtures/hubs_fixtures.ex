defmodule IotHub.HubsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `IotHub.Hubs` context.
  """

  @doc """
  Generate a hub.
  """
  def hub_fixture(attrs \\ %{}) do
    {:ok, hub} =
      attrs
      |> Enum.into(%{
        broker_url: "some broker_url",
        enabled: true,
        name: "some name"
      })
      |> IotHub.Hubs.create_hub()

    hub
  end
end
