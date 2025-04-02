defmodule IotHub.Messaging.MessageBehaviour do
  @moduledoc """
  Behaviour définissant l'interface pour un message inspiré de `wasi-messaging`.
  """

  @type topic :: String.t()
  @type metadata :: %{String.t() => String.t()}
  @type t :: term()  # Chaque implémentation peut définir son propre struct

  @callback new(binary()) :: t()
  @callback topic(t()) :: topic() | nil
  @callback content_type(t()) :: String.t() | nil
  @callback set_content_type(t(), String.t()) :: t()
  @callback data(t()) :: binary()
  @callback set_data(t(), binary()) :: t()
  @callback metadata(t()) :: metadata()
  @callback add_metadata(t(), String.t(), String.t()) :: t()
  @callback set_metadata(t(), metadata()) :: t()
  @callback remove_metadata(t(), String.t()) :: t()
end
