defmodule IotHub.CodecsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `IotHub.Codecs` context.
  """

  @doc """
  Generate a codec.
  """
  def codec_fixture(attrs \\ %{}) do
    {:ok, codec} =
      attrs
      |> Enum.into(%{
        code_or_path: "some code_or_path",
        name: "some name",
        source: :wasm_inline,
      })
      |> IotHub.Codecs.create_codec()

    codec
  end
end
