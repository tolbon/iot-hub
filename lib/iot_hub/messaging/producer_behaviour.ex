defmodule IotHub.Messaging.ProducerBehaviour do
  @moduledoc """
  Behaviour définissant une interface de producteur de messages.
  """
alias IotHub.Messaging.MessageBehaviour
alias IotHub.Messaging.ClientBehaviour

  @type client :: any()
  @type topic :: String.t()
  @type message :: binary()
  @type error :: {:error, term()}

  @callback send(client :: ClientBehaviour, topic :: topic(), message :: MessageBehaviour) :: :ok | error
end
