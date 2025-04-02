defmodule IotHub.HubsTest do
  use IotHub.DataCase

  alias IotHub.Hubs

  describe "hubs" do
    alias IotHub.Hubs.Hub

    import IotHub.HubsFixtures

    @invalid_attrs %{enabled: nil, name: nil, broker_url: nil}

    test "list_hubs/0 returns all hubs" do
      hub = hub_fixture()
      assert Hubs.list_hubs() == [hub]
    end

    test "get_hub!/1 returns the hub with given id" do
      hub = hub_fixture()
      assert Hubs.get_hub!(hub.id) == hub
    end

    test "create_hub/1 with valid data creates a hub" do
      valid_attrs = %{enabled: true, name: "some name", broker_url: "some broker_url"}

      assert {:ok, %Hub{} = hub} = Hubs.create_hub(valid_attrs)
      assert hub.enabled == true
      assert hub.name == "some name"
      assert hub.broker_url == "some broker_url"
    end

    test "create_hub/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hubs.create_hub(@invalid_attrs)
    end

    test "update_hub/2 with valid data updates the hub" do
      hub = hub_fixture()
      update_attrs = %{enabled: false, name: "some updated name", broker_url: "some updated broker_url"}

      assert {:ok, %Hub{} = hub} = Hubs.update_hub(hub, update_attrs)
      assert hub.enabled == false
      assert hub.name == "some updated name"
      assert hub.broker_url == "some updated broker_url"
    end

    test "update_hub/2 with invalid data returns error changeset" do
      hub = hub_fixture()
      assert {:error, %Ecto.Changeset{}} = Hubs.update_hub(hub, @invalid_attrs)
      assert hub == Hubs.get_hub!(hub.id)
    end

    test "delete_hub/1 deletes the hub" do
      hub = hub_fixture()
      assert {:ok, %Hub{}} = Hubs.delete_hub(hub)
      assert_raise Ecto.NoResultsError, fn -> Hubs.get_hub!(hub.id) end
    end

    test "change_hub/1 returns a hub changeset" do
      hub = hub_fixture()
      assert %Ecto.Changeset{} = Hubs.change_hub(hub)
    end
  end
end
