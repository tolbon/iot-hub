defmodule IotHub.Messaging.Amqp.Message do
  @behaviour IotHub.Messaging.MessageBehaviour

  defstruct [:data, :topic, :content_type, :metadata]

  @type t :: %__MODULE__{
          data: binary(),
          topic: String.t() | nil,
          content_type: String.t() | nil,
          metadata: Messaging.MessageBehaviour.metadata()
        }

  @impl true
  def add_metadata(message, key, value) do
    Map.update(message, :metadata, %{key => value}, &Map.put(&1, key, value))
  end

  @impl true
  def content_type(message) do
    Map.get(message, :content_type)
  end

  @impl true
  def data(message) do
    Map.get(message, :data)
  end

  @impl true
  def metadata(message) do
    Map.get(message, :metadata, %{})
  end

  @impl true
  def new(attrs) do
    Map.merge(%{data: nil, content_type: nil, metadata: %{}}, attrs)
  end

  @impl true
  def remove_metadata(message, key) do
    update_in(message[:metadata], &Map.delete(&1, key))
  end

  @impl true
  def set_content_type(message, content_type) do
    Map.put(message, :content_type, content_type)
  end

  @impl true
  def set_data(message, data) do
    Map.put(message, :data, data)
  end

  @impl true
  def set_metadata(message, metadata) do
    Map.put(message, :metadata, metadata)
  end

  @impl true
  def topic(message) do
    Map.get(message, :topic)
  end
end
