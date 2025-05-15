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

  describe "users_hubs" do
    alias IotHub.Hubs.UserHub

    import IotHub.HubsFixtures

    @invalid_attrs %{}

    test "list_users_hubs/0 returns all users_hubs" do
      user_hub = user_hub_fixture()
      assert Hubs.list_users_hubs() == [user_hub]
    end

    test "get_user_hub!/1 returns the user_hub with given id" do
      user_hub = user_hub_fixture()
      assert Hubs.get_user_hub!(user_hub.id) == user_hub
    end

    test "create_user_hub/1 with valid data creates a user_hub" do
      valid_attrs = %{}

      assert {:ok, %UserHub{} = user_hub} = Hubs.create_user_hub(valid_attrs)
    end

    test "create_user_hub/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hubs.create_user_hub(@invalid_attrs)
    end

    test "update_user_hub/2 with valid data updates the user_hub" do
      user_hub = user_hub_fixture()
      update_attrs = %{}

      assert {:ok, %UserHub{} = user_hub} = Hubs.update_user_hub(user_hub, update_attrs)
    end

    test "update_user_hub/2 with invalid data returns error changeset" do
      user_hub = user_hub_fixture()
      assert {:error, %Ecto.Changeset{}} = Hubs.update_user_hub(user_hub, @invalid_attrs)
      assert user_hub == Hubs.get_user_hub!(user_hub.id)
    end

    test "delete_user_hub/1 deletes the user_hub" do
      user_hub = user_hub_fixture()
      assert {:ok, %UserHub{}} = Hubs.delete_user_hub(user_hub)
      assert_raise Ecto.NoResultsError, fn -> Hubs.get_user_hub!(user_hub.id) end
    end

    test "change_user_hub/1 returns a user_hub changeset" do
      user_hub = user_hub_fixture()
      assert %Ecto.Changeset{} = Hubs.change_user_hub(user_hub)
    end
  end

  describe "codecs_hubs" do
    alias IotHub.Hubs.CodecHub

    import IotHub.HubsFixtures

    @invalid_attrs %{}

    test "list_codecs_hubs/0 returns all codecs_hubs" do
      codec_hub = codec_hub_fixture()
      assert Hubs.list_codecs_hubs() == [codec_hub]
    end

    test "get_codec_hub!/1 returns the codec_hub with given id" do
      codec_hub = codec_hub_fixture()
      assert Hubs.get_codec_hub!(codec_hub.id) == codec_hub
    end

    test "create_codec_hub/1 with valid data creates a codec_hub" do
      valid_attrs = %{}

      assert {:ok, %CodecHub{} = codec_hub} = Hubs.create_codec_hub(valid_attrs)
    end

    test "create_codec_hub/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Hubs.create_codec_hub(@invalid_attrs)
    end

    test "update_codec_hub/2 with valid data updates the codec_hub" do
      codec_hub = codec_hub_fixture()
      update_attrs = %{}

      assert {:ok, %CodecHub{} = codec_hub} = Hubs.update_codec_hub(codec_hub, update_attrs)
    end

    test "update_codec_hub/2 with invalid data returns error changeset" do
      codec_hub = codec_hub_fixture()
      assert {:error, %Ecto.Changeset{}} = Hubs.update_codec_hub(codec_hub, @invalid_attrs)
      assert codec_hub == Hubs.get_codec_hub!(codec_hub.id)
    end

    test "delete_codec_hub/1 deletes the codec_hub" do
      codec_hub = codec_hub_fixture()
      assert {:ok, %CodecHub{}} = Hubs.delete_codec_hub(codec_hub)
      assert_raise Ecto.NoResultsError, fn -> Hubs.get_codec_hub!(codec_hub.id) end
    end

    test "change_codec_hub/1 returns a codec_hub changeset" do
      codec_hub = codec_hub_fixture()
      assert %Ecto.Changeset{} = Hubs.change_codec_hub(codec_hub)
    end
  end
end
