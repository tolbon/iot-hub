defmodule IotHub.Devices do
  @moduledoc """
  The Devices context.
  """

  import Ecto.Query, warn: false
  alias IotHub.Repo

  alias IotHub.Devices.Device

  @doc """
  Returns the list of devices.

  ## Examples

      iex> list_devices()
      [%Device{}, ...]

  """
  def list_devices do
    Repo.all(Device)
  end

  @doc """
  Returns the list of devices in this hub.

  ## Examples

      iex> list_devices()
      [%Device{}, ...]

  """
  def list_devices_in_hub(hub_id) do
    query = from d in Device,
      where: d.hub_id == ^hub_id,
      select: d
    Repo.all(query)
  end

  @doc """
  Gets a single device.

  Raises `Ecto.NoResultsError` if the Device does not exist.

  ## Examples

      iex> get_device!(123)
      %Device{}

      iex> get_device!(456)
      ** (Ecto.NoResultsError)

  """
  def get_device!(id), do: Repo.get!(Device, id)

  @doc """
  Creates a device.

  ## Examples

      iex> create_device(%{field: value})
      {:ok, %Device{}}

      iex> create_device(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_device(attrs \\ %{}) do
    %Device{}
    |> Device.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a device.

  ## Examples

      iex> update_device(device, %{field: new_value})
      {:ok, %Device{}}

      iex> update_device(device, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_device(%Device{} = device, attrs) do
    device
    |> Device.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a device.

  ## Examples

      iex> delete_device(device)
      {:ok, %Device{}}

      iex> delete_device(device)
      {:error, %Ecto.Changeset{}}

  """
  def delete_device(%Device{} = device) do
    Repo.delete(device)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking device changes.

  ## Examples

      iex> change_device(device)
      %Ecto.Changeset{data: %Device{}}

  """
  def change_device(%Device{} = device, attrs \\ %{}) do
    Device.changeset(device, attrs)
  end

  alias IotHub.Devices.DeviceModel

  @doc """
  Returns the list of device_models.

  ## Examples

      iex> list_device_models()
      [%DeviceModel{}, ...]

  """
  def list_device_models do
    Repo.all(DeviceModel)
  end

  @doc """
  Returns the list of device_models.

  ## Examples

      iex> list_device_models()
      [%DeviceModel{}, ...]

  """
  def list_device_models_in_hub(hub_id) do
    Repo.all(from dm in DeviceModel, where: dm.hub_id == ^hub_id)
  end

  @doc """
  Gets a single device_model.

  Raises `Ecto.NoResultsError` if the Device model does not exist.

  ## Examples

      iex> get_device_model!(123)
      %DeviceModel{}

      iex> get_device_model!(456)
      ** (Ecto.NoResultsError)

  """
  def get_device_model!(id), do: Repo.get!(DeviceModel, id)

  @doc """
  Creates a device_model.

  ## Examples

      iex> create_device_model(%{field: value})
      {:ok, %DeviceModel{}}

      iex> create_device_model(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_device_model(attrs \\ %{}) do
    %DeviceModel{}
    |> DeviceModel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a device_model.

  ## Examples

      iex> update_device_model(device_model, %{field: new_value})
      {:ok, %DeviceModel{}}

      iex> update_device_model(device_model, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_device_model(%DeviceModel{} = device_model, attrs) do
    device_model
    |> DeviceModel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a device_model.

  ## Examples

      iex> delete_device_model(device_model)
      {:ok, %DeviceModel{}}

      iex> delete_device_model(device_model)
      {:error, %Ecto.Changeset{}}

  """
  def delete_device_model(%DeviceModel{} = device_model) do
    Repo.delete(device_model)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking device_model changes.

  ## Examples

      iex> change_device_model(device_model)
      %Ecto.Changeset{data: %DeviceModel{}}

  """
  def change_device_model(%DeviceModel{} = device_model, attrs \\ %{}) do
    DeviceModel.changeset(device_model, attrs)
  end


  @doc """
  Gets a single device_model.

  Raises `Ecto.NoResultsError` if the Device model does not exist.

  ## Examples

      iex> get_device_model_by_device!(123, 123)
      %DeviceModel{}

      iex> get_device_model_by_device!(456, 456)
      ** (Ecto.NoResultsError)

  """
  def get_device_model_by_device!(id, hub_id) do
    Repo.get_by!(Device, id: id, hub_id: hub_id)
    |> Repo.preload([:firmware])
    |> Repo.preload([firmware: :device_model])
  end

  alias IotHub.Devices.DeviceProperty

  @doc """
  Returns the list of device_properties.

  ## Examples

      iex> list_device_properties()
      [%DeviceProperty{}, ...]

  """
  def list_device_properties do
    Repo.all(DeviceProperty)
  end


  def list_device_properties_by_device(device_id) do
    Repo.get_by(DeviceProperty, device_id: device_id)
  end

  @doc """
  Gets a single device_property.

  Raises `Ecto.NoResultsError` if the Device property does not exist.

  ## Examples

      iex> get_device_property!(123)
      %DeviceProperty{}

      iex> get_device_property!(456)
      ** (Ecto.NoResultsError)

  """
  def get_device_property!(id), do: Repo.get!(DeviceProperty, id)

  def get_device_property_by_device_and_name(device_id, prop_name) do
    Repo.get_by(DeviceProperty, device_id: device_id, key: prop_name)
  end
  @doc """
  Creates a device_property.

  ## Examples

      iex> create_device_property(%{field: value})
      {:ok, %DeviceProperty{}}

      iex> create_device_property(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_device_property(attrs \\ %{}) do
    %DeviceProperty{}
    |> DeviceProperty.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a device_property.

  ## Examples

      iex> update_device_property(device_property, %{field: new_value})
      {:ok, %DeviceProperty{}}

      iex> update_device_property(device_property, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_device_property(%DeviceProperty{} = device_property, attrs) do
    device_property
    |> DeviceProperty.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a device_property.

  ## Examples

      iex> delete_device_property(device_property)
      {:ok, %DeviceProperty{}}

      iex> delete_device_property(device_property)
      {:error, %Ecto.Changeset{}}

  """
  def delete_device_property(%DeviceProperty{} = device_property) do
    Repo.delete(device_property)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking device_property changes.

  ## Examples

      iex> change_device_property(device_property)
      %Ecto.Changeset{data: %DeviceProperty{}}

  """
  def change_device_property(%DeviceProperty{} = device_property, attrs \\ %{}) do
    DeviceProperty.changeset(device_property, attrs)
  end

  alias IotHub.Devices.DevicePropertyHistory

  @doc """
  Returns the list of device_properties_histories.

  ## Examples

      iex> list_device_properties_histories()
      [%DevicePropertyHistory{}, ...]

  """
  def list_device_properties_histories do
    Repo.all(DevicePropertyHistory)
  end

  @doc """
  Returns the list of device_properties_histories.

  ## Examples

      iex> list_device_properties_histories()
      [%DevicePropertyHistory{}, ...]

  """
  def list_device_properties_histories(device_id, attrs \\ %{}) do
    query = from dph in DevicePropertyHistory,
      where: dph.device_id == ^device_id,
      order_by: [desc: dph.emission_at]

    query = if Map.has_key?(attrs, :start_date) and Map.has_key?(attrs, :end_date) do
      query |> where([dph], dph.emission_at >= ^attrs.start_date and dph.emission_at <= ^attrs.end_date)
    else
      query
    end

    query = if Map.has_key?(attrs, :key) do
      from dph in query,
      where: dph.key == ^attrs.key
    else
      query
    end

    Repo.all(query)
  end

  @doc """
  Gets a single device_property_history.

  Raises `Ecto.NoResultsError` if the Device property history does not exist.

  ## Examples

      iex> get_device_property_history!(123)
      %DevicePropertyHistory{}

      iex> get_device_property_history!(456)
      ** (Ecto.NoResultsError)

  """
  def get_device_property_history!(id), do: Repo.get!(DevicePropertyHistory, id)
  @doc """
  Creates a device_property_history.

  ## Examples

      iex> create_device_property_history(%{field: value})
      {:ok, %DevicePropertyHistory{}}

      iex> create_device_property_history(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_device_property_history(attrs \\ %{}) do
    %DevicePropertyHistory{}
    |> DevicePropertyHistory.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a device_property_history.

  ## Examples

      iex> update_device_property_history(device_property_history, %{field: new_value})
      {:ok, %DevicePropertyHistory{}}

      iex> update_device_property_history(device_property_history, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_device_property_history(%DevicePropertyHistory{} = device_property_history, attrs) do
    device_property_history
    |> DevicePropertyHistory.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a device_property_history.

  ## Examples

      iex> delete_device_property_history(device_property_history)
      {:ok, %DevicePropertyHistory{}}

      iex> delete_device_property_history(device_property_history)
      {:error, %Ecto.Changeset{}}

  """
  def delete_device_property_history(%DevicePropertyHistory{} = device_property_history) do
    Repo.delete(device_property_history)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking device_property_history changes.

  ## Examples

      iex> change_device_property_history(device_property_history)
      %Ecto.Changeset{data: %DevicePropertyHistory{}}

  """
  def change_device_property_history(%DevicePropertyHistory{} = device_property_history, attrs \\ %{}) do
    DevicePropertyHistory.changeset(device_property_history, attrs)
  end
end
