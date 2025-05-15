defmodule IotHub.TcpServer do
  use GenServer
  require Logger
  alias Phoenix.PubSub

  @tcp_port 4040  # Port d'écoute TCP

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @impl true
  def init(opts) do
    port = Keyword.get(opts, :port, @tcp_port)
    Logger.info("Starting TCP Server on port #{port}")

    # Démarrer le serveur TCP
    case :gen_tcp.listen(port, [:binary, packet: :line, active: true, reuseaddr: true]) do
      {:ok, socket} ->
        # Commencer à accepter les connexions
        Process.send_after(self(), :accept, 0)
        {:ok, %{socket: socket, clients: %{}}}
      {:error, reason} ->
        Logger.error("Failed to start TCP server: #{inspect(reason)}")
        {:stop, reason}
    end
  end

  @impl true
  def handle_info(:accept, %{socket: socket} = state) do
    case :gen_tcp.accept(socket) do
      {:ok, client} ->
        # Gérer la nouvelle connexion dans un processus séparé
        {:ok, pid} = Task.Supervisor.start_child(
          IotHub.TcpClientSupervisor,
          fn -> handle_client(client) end
        )
        :gen_tcp.controlling_process(client, pid)

        # Continuer à accepter d'autres connexions
        Process.send_after(self(), :accept, 0)
        {:noreply, state}

      {:error, reason} ->
        Logger.error("Error accepting TCP connection: #{inspect(reason)}")
        Process.send_after(self(), :accept, 1000)  # Retry after delay
        {:noreply, state}
    end
  end

  # Gérer les messages TCP
  defp handle_client(socket) do
    receive do
      {:tcp, ^socket, data} ->
        data = String.trim(data)
        Logger.debug("TCP received: #{data}")

        # Extraire le hub et le device ID des données
        case parse_message(data) do
          {:ok, hub_id, device_id, message} ->
            # Publier le message via PubSub
            topic = "device:#{hub_id}:#{device_id}"
            PubSub.broadcast(IotHub.PubSub, topic, {:device_message, message})

            # Répondre au client TCP si nécessaire
            :gen_tcp.send(socket, "ACK\n")

          :error ->
            :gen_tcp.send(socket, "ERROR: Invalid format\n")
        end

        # Continuer à traiter les messages du même client
        handle_client(socket)

      {:tcp_closed, ^socket} ->
        Logger.info("TCP client disconnected")

      {:tcp_error, ^socket, reason} ->
        Logger.error("TCP error: #{inspect(reason)}")
    end
  end

  # Analyser le message TCP (à adapter selon votre format)
  defp parse_message(data) do
    case JSON.decode(data) do
      {:ok, %{"hub" => hub_id, "device" => device_id} = message} ->
        {:ok, hub_id, device_id, message}
      _ ->
        :error
    end
  end
end
