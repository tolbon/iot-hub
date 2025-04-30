defmodule IotHub.Worker.SenderAction do
  use GenServer
  require Logger

  @exchange "amq.topic"

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    amqp_url = Keyword.get(opts, :amqp_url)
    ssl_options = Keyword.get(opts, :ssl_options)
    amqp_connection = Keyword.get(opts, :amqp_connection, AMQP.Connection)

    Logger.info("Connecting to RabbitMQ with URL: #{amqp_url}")

    case amqp_connection.open(amqp_url, ssl_options: ssl_options) do
      {:ok, conn} ->
        case AMQP.Channel.open(conn) do
          {:ok, chan} ->
            Process.monitor(conn.pid)
            Process.monitor(chan.pid)
            {:ok, %{conn: conn, chan: chan}}
          {:error, reason} ->
            Logger.error("Failed to open channel: #{inspect(reason)}")
            {:stop, reason}
        end
      {:error, reason} ->
        Logger.error("Failed to connect to RabbitMQ: #{inspect(reason)}")
        {:stop, reason}
    end
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, pid, _reason}, %{conn: %{pid: pid}} = state) do
    Logger.error("RabbitMQ connection lost")
    {:stop, :connection_lost, state}
  end

  @impl true
  def handle_info({:DOWN, _ref, :process, pid, _reason}, %{chan: %{pid: pid}} = state) do
    Logger.error("RabbitMQ channel lost")
    {:stop, :channel_lost, state}
  end

  def publish(routing_key, payload) do
    GenServer.call(__MODULE__, {:publish, routing_key, payload})
  end

  @impl true
  def handle_call({:publish, routing_key, payload}, _from, %{chan: chan} = state) do
    case AMQP.Basic.publish(chan, @exchange, routing_key, payload) do
      :ok ->
        {:reply, :ok, state}
      {:error, reason} ->
        Logger.error("Failed to publish message: #{inspect(reason)}")
        {:reply, {:error, reason}, state}
    end
  end
end
