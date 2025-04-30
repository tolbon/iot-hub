defmodule IotHub.Firmwares do
  @moduledoc """
  The Firmwares context.
  """

  import Ecto.Query, warn: false
  alias IotHub.Repo

  alias IotHub.Firmwares.Firmware

  @doc """
  Returns the list of firmwares.

  ## Examples

      iex> list_firmwares()
      [%Firmware{}, ...]

  """
  def list_firmwares do
    Repo.all(Firmware)
  end

  @doc """
  Returns the list of firmwares.

  ## Examples

      iex> list_firmwares()
      [%Firmware{}, ...]

  """
  def list_firmwares_in_hub(hub_id) do
    query = from f in Firmware,
      where: f.hub_id == ^hub_id
    Repo.all(query)
  end


  @doc """
  Gets a single firmware.

  Raises `Ecto.NoResultsError` if the Firmware does not exist.

  ## Examples

      iex> get_firmware!(123)
      %Firmware{}

      iex> get_firmware!(456)
      ** (Ecto.NoResultsError)

  """
  def get_firmware!(id), do: Repo.get!(Firmware, id)

  @doc """
  Creates a firmware.

  ## Examples

      iex> create_firmware(%{field: value})
      {:ok, %Firmware{}}

      iex> create_firmware(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_firmware(attrs \\ %{}) do
    %Firmware{}
    |> Firmware.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a firmware.

  ## Examples

      iex> update_firmware(firmware, %{field: new_value})
      {:ok, %Firmware{}}

      iex> update_firmware(firmware, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_firmware(%Firmware{} = firmware, attrs) do
    firmware
    |> Firmware.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a firmware.

  ## Examples

      iex> delete_firmware(firmware)
      {:ok, %Firmware{}}

      iex> delete_firmware(firmware)
      {:error, %Ecto.Changeset{}}

  """
  def delete_firmware(%Firmware{} = firmware) do
    Repo.delete(firmware)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking firmware changes.

  ## Examples

      iex> change_firmware(firmware)
      %Ecto.Changeset{data: %Firmware{}}

  """
  def change_firmware(%Firmware{} = firmware, attrs \\ %{}) do
    Firmware.changeset(firmware, attrs)
  end
end
