defmodule IotHub.Worker.HubWorker do
  use GenServer
  use AMQP
  require IotHub
  require Logger

  @exchange    "amq.topic"
  @queue       "hub_worker_"
  @queue_error "_error"

  def start_link(opts) do
    Logger.info("Start link HubWorker for hub #{opts[:hub_name]}")
    GenServer.start_link(__MODULE__, opts, name: {:global, opts[:hub_name]})
  end

  @impl true
  def init(opts) do
    Logger.info("Init HubWorker for hub #{opts[:hub_name]}")

    amqp_url = Keyword.get(opts, :amqp_url)
    ssl_options = Keyword.get(opts, :ssl_options)
    amqp_connection = Keyword.get(opts, :amqp_connection)
    hub_name = Keyword.get(opts, :hub_name)

    Logger.info("AMQP URL: #{inspect(ssl_options)}")
    Logger.info("Starting HubWorker with AMQP URL: #{amqp_url}")
    with {:ok, conn} <- amqp_connection.open(amqp_url, ssl_options: ssl_options),
       {:ok, chan} <- Channel.open(conn) do
      setup_queue(chan, hub_name)
      Logger.info("Queue setup complete for hub #{hub_name}")
      # Monitor the connection and channel PIDs
      Process.monitor(conn.pid)
      Process.monitor(chan.pid)

      {:ok, %{conn: conn, chan: chan, hub_name: hub_name}}
    else
      {:error, reason} ->
      Logger.error("Failed to initialize HubWorker for hub #{hub_name}: #{inspect(reason)}")
      {:ok, reason}
    end
  end

  # Confirmation sent by the broker after registering this process as a consumer
  def handle_info({:basic_consume_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  # Sent by the broker when the consumer is unexpectedly cancelled (such as after a queue deletion)
  def handle_info({:basic_cancel, %{consumer_tag: _consumer_tag}}, chan) do
    {:stop, :normal, chan}
  end

  # Confirmation sent by the broker to the consumer process after a Basic.cancel
  def handle_info({:basic_cancel_ok, %{consumer_tag: _consumer_tag}}, chan) do
    {:noreply, chan}
  end

  def handle_info({:basic_deliver, payload, meta}, %{chan: chan} = state) do
    # You might want to run payload consumption in separate Tasks in production
    consume(chan, meta.delivery_tag, meta.redelivered, meta.routing_key, payload)
    {:noreply, state}
  end

  defp setup_queue(chan, hub_name) do
    Logger.info("Setting up queue for hub #{hub_name}")
    {:ok, _} = Queue.declare(chan, hub_name <> @queue_error, durable: true, arguments: [
      {"x-queue-type", :longstr, "quorum"},
    ])
    # Messages that cannot be delivered to any consumer in the main queue will be routed to the error queue
    {:ok, _} = Queue.declare(chan, @queue <> hub_name,
                             durable: true,
                             arguments: [
                               {"x-queue-type", :longstr, "quorum"},
                               {"x-dead-letter-exchange", :longstr, ""},
                               {"x-dead-letter-routing-key", :longstr, hub_name <> @queue_error}
                             ]
                            )
    :ok = Queue.bind(chan, @queue <> hub_name, @exchange, routing_key: hub_name <> ".d.*.ev.*")
    :ok = Queue.bind(chan, @queue <> hub_name, @exchange, routing_key: hub_name <> ".d.*.event.*")


    # Limit unacknowledged messages to 10
    :ok = Basic.qos(chan, prefetch_count: 10)
    # Register the GenServer process as a consumer
    {:ok, _consumer_tag} = Basic.consume(chan, @queue <> hub_name)

  end

  defp consume(channel, tag, redelivered, routing_key, payload) do
    splited_routing_key = routing_key|>String.split(".")
    Logger.info("Consuming message with routing key: #{routing_key}")
    case splited_routing_key do
      [hub_id, _com_type, device_id, _ev, event_type] -> consume_hub_broker(channel, hub_id, device_id, event_type, tag, payload)
      split ->
        Logger.info("Unknown routing key: #{inspect(split)}")
        :ok = Basic.reject(channel, tag, requeue: not redelivered)
    end
  rescue
    # Requeue unless it's a redelivered message.
    # This means we will retry consuming a message once in case of exception
    # before we give up and have it moved to the error queue
    #
    # You might also want to catch :exit signal in production code.
    # Make sure you call ack, nack or reject otherwise consumer will stop
    # receiving messages.
    exception ->
      Logger.error("Error consuming message: #{inspect(exception)}")
      :ok = Basic.reject(channel, tag, requeue: not redelivered)
      Logger.warning("Error converting #{payload} to integer")
  end
  def flatten_map(map, parent_key \\ "", acc \\ %{}) do
    Enum.reduce(map, acc, fn {key, value}, acc ->
      full_key = if parent_key == "", do: key, else: "#{parent_key}.#{key}"
      case value do
        %{} -> flatten_map(value, full_key, acc)
        _ -> Map.put(acc, full_key, value)
      end
    end)
  end

  def publish_action(routing_key, payload) do
    GenServer.call(__MODULE__, {:publish_action, routing_key, payload})
  end

  def publish_hook(routing_key, payload) do
    GenServer.call(__MODULE__, {:publish_hook, routing_key, payload})
  end

  @impl true
  def handle_call({:publish_action, routing_key, payload}, _from, %{chan: chan} = state) do
    case AMQP.Basic.publish(chan, @exchange, routing_key, payload) do
      :ok ->
        {:reply, :ok, state}
      {:error, reason} ->
        Logger.error("Failed to publish message: #{inspect(reason)}")
        {:reply, {:error, reason}, state}
    end
  end

  @impl true
  def handle_call({:publish_hook, routing_key, payload}, _from, %{chan: chan} = state) do
    case AMQP.Basic.publish(chan, @exchange, routing_key, payload) do
      :ok ->
        {:reply, :ok, state}
      {:error, reason} ->
        Logger.error("Failed to publish message: #{inspect(reason)}")
        {:reply, {:error, reason}, state}
    end
  end

  defp consume_hub_broker(channel, hub_name, device_id, event_type, tag, payload) do
    # Assuming you have a schema module named HubBroker and a Repo module for database interactions
    hub = IotHub.Hubs.get_hub_by_name!(hub_name)
    device = IotHub.Devices.get_device_model_by_device!(device_id, hub.id)

    case JSON.decode(payload) do
      {:ok, data} ->
        Logger.info("Decoded payload: #{device_id} - #{event_type} - #{inspect(data)}")

        case IotHub.Devices.get_device_model_by_device!(device_id, hub.id) do
          device ->
            wot_schema_decoded = device.firmware.device_model.schema
            event_schema = wot_schema_decoded
                          |>Map.get("events")
                          |>Map.get(event_type)
                          |>Map.get("data")
            case event_schema do
                nil ->
                :ok = Basic.reject(channel, tag, requeue: false)
                Logger.warning("Failed to get event schema.")
              _ -> nil
            end
            xema_schema = event_schema |> JsonXema.new();
            Logger.info("Payload Xema #{inspect(xema_schema)}")
            # Valid le payload et event schema en JSON Schema
            # TODO : Le payload eut etre autre chose que du json type avro ou protobuf
            if JsonXema.valid?(xema_schema, data) == false do
              Logger.warning("Failed to validate payload.")
              :ok = Basic.reject channel, tag, requeue: false
            end

            # Si c'est valid je recupere toutes les props dans payload et je les sauvegarde dans la base de donnees historique et dans device property
            flattened_props = flatten_map(data|>Map.get("props", %{}))
            Logger.info("Payload #{inspect(flattened_props)}")
            flattened_props
            |> Enum.map(fn {k, v} ->
              value_type = get_value_type(v)
              numeric_value = get_numeric_value(v)
              string_value = to_string(v)
              emission_at = case Map.get(data, "ts") do
                nil -> DateTime.utc_now()
                ts ->
                  case Integer.parse(ts) do
                    {int_ts, _} -> DateTime.from_unix!(int_ts)
                    :error -> DateTime.utc_now()
                  end
              end
              Logger.info("Saving property #{k} with value #{v} and type #{value_type}: '#{string_value}' // #{emission_at}")
              # Save property in DevicePropertyHistory
              case IotHub.Devices.create_device_property_history(%{
                emission_at: emission_at,
                device_id: device_id,
                key: k,
                string_value: string_value,
                value_type: value_type,
                number_value: numeric_value
              }) do
                {:ok, _} -> nil
                {:error, _reason} -> Logger.warning("Failed to save property in history." )
               end
              # Save the property in the database
              case IotHub.Devices.get_device_property_by_device_and_name(device_id, k) do
                {:ok, device_property} ->
                  # Update the property
                  case IotHub.Devices.update_device_property(device_property, %{string_value: string_value, value_type: value_type, number_value: numeric_value})
                  do
                    {:ok, _} -> nil
                    {:error, reason} -> Logger.warning("Failed to update property. #{reason}" )
                   end
                nil ->
                Logger.info("Saving property #{k} with value #{v} and type #{value_type}: '#{string_value}' // #{numeric_value}")

                  # Create the property
                  case IotHub.Devices.create_device_property(%{
                    device_id: device_id,
                    key: k,
                    string_value: string_value,
                    value_type: value_type,
                    number_value: numeric_value
                  }) do
                    {:ok, _} -> nil
                    {:error, reason} -> Logger.warning("Failed to save property. #{reason}" )
                   end
              end
            end)
            IotHub.Devices.update_device(device, %{last_seen_at: DateTime.utc_now()})
            IotHub.Worker.SenderAction.publish(hub_name <> ".d." <> device_id <>".hook." <> event_type, payload)

          {:error, _reason} ->
            :ok = Basic.reject channel, tag, requeue: false
            Logger.warning("Failed to get device model.");
        end
        :ok = Basic.ack channel, tag
        Logger.warning("Payload consumed and saved to database.");

      {:error, _reason} ->
        :ok = Basic.reject channel, tag, requeue: false
        Logger.warning("Failed to decode payload.");
    end
  rescue
    exception ->
      Logger.error("Error processing payload: #{inspect(exception)}")
      :ok = Basic.reject(channel, tag, requeue: false)
      Logger.warning("Error processing payload: #{inspect(exception)}")
  end

  defp json_to_map(json) do
    case JSON.decode(json) do
      {:ok, data} -> data
      {:error, _reason} -> %{}
    end
  end

  defp get_value_type(value) do
    cond do
      is_integer(value) -> "integer"
      is_float(value) -> "float"
      is_boolean(value) -> "boolean"
      is_binary(value) -> "string"
      true -> "unknown"
    end
  end

  defp get_numeric_value(value) do
    cond do
      is_integer(value) -> value
      is_float(value) -> value
      true -> nil
    end
  end
end
