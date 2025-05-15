defmodule IotHub.Codecs do
  @moduledoc """
  The Codecs context.
  """

  import Ecto.Query, warn: false
  alias IotHub.Repo

  alias IotHub.Codecs.Codec

  @doc """
  Returns the list of codecs.

  ## Examples

      iex> list_codecs()
      [%Codec{}, ...]

  """
  def list_codecs do
    Repo.all(Codec)
  end

  @doc """
  Gets a single codec.

  Raises `Ecto.NoResultsError` if the Codec does not exist.

  ## Examples

      iex> get_codec!(123)
      %Codec{}

      iex> get_codec!(456)
      ** (Ecto.NoResultsError)

  """
  def get_codec!(id), do: Repo.get!(Codec, id)

  @doc """
  Creates a codec.

  ## Examples

      iex> create_codec(%{field: value})
      {:ok, %Codec{}}

      iex> create_codec(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_codec(attrs \\ %{}) do
    %Codec{}
    |> Codec.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a codec.

  ## Examples

      iex> update_codec(codec, %{field: new_value})
      {:ok, %Codec{}}

      iex> update_codec(codec, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_codec(%Codec{} = codec, attrs) do
    codec
    |> Codec.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a codec.

  ## Examples

      iex> delete_codec(codec)
      {:ok, %Codec{}}

      iex> delete_codec(codec)
      {:error, %Ecto.Changeset{}}

  """
  def delete_codec(%Codec{} = codec) do
    Repo.delete(codec)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking codec changes.

  ## Examples

      iex> change_codec(codec)
      %Ecto.Changeset{data: %Codec{}}

  """
  def change_codec(%Codec{} = codec, attrs \\ %{}) do
    Codec.changeset(codec, attrs)
  end
end
