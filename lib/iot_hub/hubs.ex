defmodule IotHub.Hubs do
  @moduledoc """
  The Hubs context.
  """

  import Ecto.Query, warn: false
  alias IotHub.Repo

  alias IotHub.Hubs.Hub

  @doc """
  Returns the list of hubs.

  ## Examples

      iex> list_hubs()
      [%Hub{}, ...]

  """
  def list_hubs do
    Repo.all(Hub)
  end

  @doc """
  Returns the list of hubs I have.

  ## Examples

      iex> list_hubs()
      [%Hub{}, ...]

  """
  def list_my_hubs(user_id) do
    query = from h in Hub,
      join: uh in UserHub, on: uh.hub_id == h.id,
      where: uh.user_id == ^user_id
    Repo.all(query)
  end

  def list_enabled_hubs do
    Repo.all(from h in Hub, where: h.enabled == true)
  end
  @doc """
  Gets a single hub.

  Raises `Ecto.NoResultsError` if the Hub does not exist.

  ## Examples

      iex> get_hub!(123)
      %Hub{}

      iex> get_hub!(456)
      ** (Ecto.NoResultsError)

  """
  def get_hub!(id), do: Repo.get!(Hub, id)

  def get_hub_by_name!(name), do: Repo.get_by!(Hub, name: name)

  def get_url!(id) do
    hub = Repo.get!(Hub, id)
    uri = URI.parse(hub.broker_url)
    get_broker_scheme(uri)
  end

  defp get_broker_scheme(%URI{scheme: "amqp"} = http) do
    http.host
  end


  defp get_broker_scheme(%URI{scheme: "linklayer"} = http) do
    http.host
  end


  @doc """
  Creates a hub.

  ## Examples

      iex> create_hub(%{field: value})
      {:ok, %Hub{}}

      iex> create_hub(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_hub(attrs \\ %{}) do
    %Hub{}
    |> Hub.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a hub.

  ## Examples

      iex> update_hub(hub, %{field: new_value})
      {:ok, %Hub{}}

      iex> update_hub(hub, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_hub(%Hub{} = hub, attrs) do
    hub
    |> Hub.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a hub.

  ## Examples

      iex> delete_hub(hub)
      {:ok, %Hub{}}

      iex> delete_hub(hub)
      {:error, %Ecto.Changeset{}}

  """
  def delete_hub(%Hub{} = hub) do
    Repo.delete(hub)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking hub changes.

  ## Examples

      iex> change_hub(hub)
      %Ecto.Changeset{data: %Hub{}}

  """
  def change_hub(%Hub{} = hub, attrs \\ %{}) do
    Hub.changeset(hub, attrs)
  end

  alias IotHub.Hubs.UserHub

  @doc """
  Returns the list of users_hubs.

  ## Examples

      iex> list_users_hubs()
      [%UserHub{}, ...]

  """
  def list_users_hubs do
    Repo.all(UserHub)
  end

  @doc """
  Gets a single user_hub.

  Raises `Ecto.NoResultsError` if the User hub does not exist.

  ## Examples

      iex> get_user_hub!(123)
      %UserHub{}

      iex> get_user_hub!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_hub!(id), do: Repo.get!(UserHub, id)

  @doc """
  Creates a user_hub.

  ## Examples

      iex> create_user_hub(%{field: value})
      {:ok, %UserHub{}}

      iex> create_user_hub(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_hub(attrs \\ %{}) do
    %UserHub{}
    |> UserHub.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_hub.

  ## Examples

      iex> update_user_hub(user_hub, %{field: new_value})
      {:ok, %UserHub{}}

      iex> update_user_hub(user_hub, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_hub(%UserHub{} = user_hub, attrs) do
    user_hub
    |> UserHub.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_hub.

  ## Examples

      iex> delete_user_hub(user_hub)
      {:ok, %UserHub{}}

      iex> delete_user_hub(user_hub)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_hub(%UserHub{} = user_hub) do
    Repo.delete(user_hub)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_hub changes.

  ## Examples

      iex> change_user_hub(user_hub)
      %Ecto.Changeset{data: %UserHub{}}

  """
  def change_user_hub(%UserHub{} = user_hub, attrs \\ %{}) do
    UserHub.changeset(user_hub, attrs)
  end
end
