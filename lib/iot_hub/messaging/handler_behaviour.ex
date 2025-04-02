defmodule IotHub.Messaging.HandlerBehaviour do
  @moduledoc """
  Behaviour définissant un gestionnaire de messages entrants.
  """
alias IotHub.Messaging.MessageBehaviour

  @type message :: binary()
  @type error :: {:error, term()}

  @callback handle(message :: MessageBehaviour) :: :ok | error
end
