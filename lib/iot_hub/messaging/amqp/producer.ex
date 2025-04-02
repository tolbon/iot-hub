defmodule IotHub.Messaging.Producer do
  alias IotHub.Messaging.Amqp.Client
  @behaviour IotHub.Messaging.ProducerBehaviour

  @impl true
  def send(Client = client, topic, message) do
    case client.publish(client, topic, message) do
      :ok -> :ok
      {:error, reason} -> {:error, reason}
    end
  end

end
