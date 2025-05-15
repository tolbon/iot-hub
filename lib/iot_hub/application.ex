defmodule IotHub.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      IotHubWeb.Telemetry,
      IotHub.Repo,
      {DNSCluster, query: Application.get_env(:iot_hub, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: IotHub.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: IotHub.Finch},
      # Start a worker by calling: IotHub.Worker.start_link(arg)
      # {IotHub.Worker, arg},
      # Start to serve requests, typically the last entry
      IotHubWeb.Endpoint,
      {IotHub.TcpServer, [port: 4040]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: IotHub.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    IotHubWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
