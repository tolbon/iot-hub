defmodule IotHub.Messaging.Amqp.Handler do
  @behaviour IotHub.Messaging.HandlerBehaviour
  alias IotHub.Messaging.Amqp.Message

  @impl true
  def handle(%Message{} = message) do
    {:ok, message}
  end
end
