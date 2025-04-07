defmodule IotHub.DevicesTest do
  use IotHub.DataCase

  alias IotHub.Devices

  describe "devices" do
    alias IotHub.Devices.Device

    import IotHub.DevicesFixtures

    @invalid_attrs %{name: nil, last_seen_at: nil}

    test "list_devices/0 returns all devices" do
      device = device_fixture()
      assert Devices.list_devices() == [device]
    end

    test "get_device!/1 returns the device with given id" do
      device = device_fixture()
      assert Devices.get_device!(device.id) == device
    end

    test "create_device/1 with valid data creates a device" do
      valid_attrs = %{name: "some name", last_seen_at: ~U[2025-04-03 20:54:00Z]}

      assert {:ok, %Device{} = device} = Devices.create_device(valid_attrs)
      assert device.name == "some name"
      assert device.last_seen_at == ~U[2025-04-03 20:54:00Z]
    end

    test "create_device/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Devices.create_device(@invalid_attrs)
    end

    test "update_device/2 with valid data updates the device" do
      device = device_fixture()
      update_attrs = %{name: "some updated name", last_seen_at: ~U[2025-04-04 20:54:00Z]}

      assert {:ok, %Device{} = device} = Devices.update_device(device, update_attrs)
      assert device.name == "some updated name"
      assert device.last_seen_at == ~U[2025-04-04 20:54:00Z]
    end

    test "update_device/2 with invalid data returns error changeset" do
      device = device_fixture()
      assert {:error, %Ecto.Changeset{}} = Devices.update_device(device, @invalid_attrs)
      assert device == Devices.get_device!(device.id)
    end

    test "delete_device/1 deletes the device" do
      device = device_fixture()
      assert {:ok, %Device{}} = Devices.delete_device(device)
      assert_raise Ecto.NoResultsError, fn -> Devices.get_device!(device.id) end
    end

    test "change_device/1 returns a device changeset" do
      device = device_fixture()
      assert %Ecto.Changeset{} = Devices.change_device(device)
    end
  end

  describe "device_models" do
    alias IotHub.Devices.DeviceModel

    import IotHub.DevicesFixtures

    @invalid_attrs %{name: nil, version: nil, schema: nil}

    test "list_device_models/0 returns all device_models" do
      device_model = device_model_fixture()
      assert Devices.list_device_models() == [device_model]
    end

    test "get_device_model!/1 returns the device_model with given id" do
      device_model = device_model_fixture()
      assert Devices.get_device_model!(device_model.id) == device_model
    end

    test "create_device_model/1 with valid data creates a device_model" do
      valid_attrs = %{name: "some name", version: "some version", schema: %{}}

      assert {:ok, %DeviceModel{} = device_model} = Devices.create_device_model(valid_attrs)
      assert device_model.name == "some name"
      assert device_model.version == "some version"
      assert device_model.schema == %{}
    end

    test "create_device_model/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Devices.create_device_model(@invalid_attrs)
    end

    test "update_device_model/2 with valid data updates the device_model" do
      device_model = device_model_fixture()
      update_attrs = %{name: "some updated name", version: "some updated version", schema: %{}}

      assert {:ok, %DeviceModel{} = device_model} = Devices.update_device_model(device_model, update_attrs)
      assert device_model.name == "some updated name"
      assert device_model.version == "some updated version"
      assert device_model.schema == %{}
    end

    test "update_device_model/2 with invalid data returns error changeset" do
      device_model = device_model_fixture()
      assert {:error, %Ecto.Changeset{}} = Devices.update_device_model(device_model, @invalid_attrs)
      assert device_model == Devices.get_device_model!(device_model.id)
    end

    test "delete_device_model/1 deletes the device_model" do
      device_model = device_model_fixture()
      assert {:ok, %DeviceModel{}} = Devices.delete_device_model(device_model)
      assert_raise Ecto.NoResultsError, fn -> Devices.get_device_model!(device_model.id) end
    end

    test "change_device_model/1 returns a device_model changeset" do
      device_model = device_model_fixture()
      assert %Ecto.Changeset{} = Devices.change_device_model(device_model)
    end
  end

  describe "device_properties" do
    alias IotHub.Devices.DeviceProperty

    import IotHub.DevicesFixtures

    @invalid_attrs %{key: nil, number_value: nil, value_type: nil, string_value: nil}

    test "list_device_properties/0 returns all device_properties" do
      device_property = device_property_fixture()
      assert Devices.list_device_properties() == [device_property]
    end

    test "get_device_property!/1 returns the device_property with given id" do
      device_property = device_property_fixture()
      assert Devices.get_device_property!(device_property.id) == device_property
    end

    test "create_device_property/1 with valid data creates a device_property" do
      valid_attrs = %{key: "some key", number_value: 120.5, value_type: "some value_type", string_value: "some string_value"}

      assert {:ok, %DeviceProperty{} = device_property} = Devices.create_device_property(valid_attrs)
      assert device_property.key == "some key"
      assert device_property.number_value == 120.5
      assert device_property.value_type == "some value_type"
      assert device_property.string_value == "some string_value"
    end

    test "create_device_property/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Devices.create_device_property(@invalid_attrs)
    end

    test "update_device_property/2 with valid data updates the device_property" do
      device_property = device_property_fixture()
      update_attrs = %{key: "some updated key", number_value: 456.7, value_type: "some updated value_type", string_value: "some updated string_value"}

      assert {:ok, %DeviceProperty{} = device_property} = Devices.update_device_property(device_property, update_attrs)
      assert device_property.key == "some updated key"
      assert device_property.number_value == 456.7
      assert device_property.value_type == "some updated value_type"
      assert device_property.string_value == "some updated string_value"
    end

    test "update_device_property/2 with invalid data returns error changeset" do
      device_property = device_property_fixture()
      assert {:error, %Ecto.Changeset{}} = Devices.update_device_property(device_property, @invalid_attrs)
      assert device_property == Devices.get_device_property!(device_property.id)
    end

    test "delete_device_property/1 deletes the device_property" do
      device_property = device_property_fixture()
      assert {:ok, %DeviceProperty{}} = Devices.delete_device_property(device_property)
      assert_raise Ecto.NoResultsError, fn -> Devices.get_device_property!(device_property.id) end
    end

    test "change_device_property/1 returns a device_property changeset" do
      device_property = device_property_fixture()
      assert %Ecto.Changeset{} = Devices.change_device_property(device_property)
    end
  end

  describe "device_properties_histories" do
    alias IotHub.Devices.DevicePropertyHistory

    import IotHub.DevicesFixtures

    @invalid_attrs %{key: nil, number_value: nil, emission_at: nil, value_type: nil, string_value: nil}

    test "list_device_properties_histories/0 returns all device_properties_histories" do
      device_property_history = device_property_history_fixture()
      assert Devices.list_device_properties_histories() == [device_property_history]
    end

    test "get_device_property_history!/1 returns the device_property_history with given id" do
      device_property_history = device_property_history_fixture()
      assert Devices.get_device_property_history!(device_property_history.id) == device_property_history
    end

    test "create_device_property_history/1 with valid data creates a device_property_history" do
      valid_attrs = %{key: "some key", number_value: 120.5, emission_at: ~U[2025-04-03 21:05:00.000000Z], value_type: "some value_type", string_value: "some string_value"}

      assert {:ok, %DevicePropertyHistory{} = device_property_history} = Devices.create_device_property_history(valid_attrs)
      assert device_property_history.key == "some key"
      assert device_property_history.number_value == 120.5
      assert device_property_history.emission_at == ~U[2025-04-03 21:05:00.000000Z]
      assert device_property_history.value_type == "some value_type"
      assert device_property_history.string_value == "some string_value"
    end

    test "create_device_property_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Devices.create_device_property_history(@invalid_attrs)
    end

    test "update_device_property_history/2 with valid data updates the device_property_history" do
      device_property_history = device_property_history_fixture()
      update_attrs = %{key: "some updated key", number_value: 456.7, emission_at: ~U[2025-04-04 21:05:00.000000Z], value_type: "some updated value_type", string_value: "some updated string_value"}

      assert {:ok, %DevicePropertyHistory{} = device_property_history} = Devices.update_device_property_history(device_property_history, update_attrs)
      assert device_property_history.key == "some updated key"
      assert device_property_history.number_value == 456.7
      assert device_property_history.emission_at == ~U[2025-04-04 21:05:00.000000Z]
      assert device_property_history.value_type == "some updated value_type"
      assert device_property_history.string_value == "some updated string_value"
    end

    test "update_device_property_history/2 with invalid data returns error changeset" do
      device_property_history = device_property_history_fixture()
      assert {:error, %Ecto.Changeset{}} = Devices.update_device_property_history(device_property_history, @invalid_attrs)
      assert device_property_history == Devices.get_device_property_history!(device_property_history.id)
    end

    test "delete_device_property_history/1 deletes the device_property_history" do
      device_property_history = device_property_history_fixture()
      assert {:ok, %DevicePropertyHistory{}} = Devices.delete_device_property_history(device_property_history)
      assert_raise Ecto.NoResultsError, fn -> Devices.get_device_property_history!(device_property_history.id) end
    end

    test "change_device_property_history/1 returns a device_property_history changeset" do
      device_property_history = device_property_history_fixture()
      assert %Ecto.Changeset{} = Devices.change_device_property_history(device_property_history)
    end
  end
end
