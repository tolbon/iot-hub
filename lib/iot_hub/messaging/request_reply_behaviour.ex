defmodule IotHub.Messaging.RequestReplyBehaviour do
  @moduledoc """
  Interface pour le pattern Request-Reply dans un système de messagerie.
  """

  alias IotHub.Messaging.ClientBehaviour
  alias IotHub.Messaging.MessageBehaviour
  @type topic :: String.t()
  @type error :: {:error, term()}

  @callback request(
              client :: ClientBehaviour.t(),
              topic :: topic(),
              message :: MessageBehaviour.t(),
              options :: RequestOptions.t() | nil
            ) :: {:ok, list(Message.t())} | error()

  @callback reply(
              reply_to :: MessageBehaviour.t(),
              message :: MessageBehaviour.t()
            ) :: :ok | error()
end
