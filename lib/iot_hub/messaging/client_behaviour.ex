defmodule IotHub.Messaging.ClientBehaviour do
  @moduledoc """
  Behaviour définissant un client de messagerie.
  """

  @type t :: any()
  @type error :: {:error, term()}

  @callback connect(name :: String.t()) :: {:ok, t()} | error
  @callback disconnect(client :: t()) :: :ok | error
end
