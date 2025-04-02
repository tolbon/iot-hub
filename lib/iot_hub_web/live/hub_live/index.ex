defmodule IotHubWeb.HubLive.Index do
  use IotHubWeb, :live_view

  alias IotHub.Hubs
  alias IotHub.Hubs.Hub

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :hubs, Hubs.list_hubs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Hub")
    |> assign(:hub, Hubs.get_hub!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Hub")
    |> assign(:hub, %Hub{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Hubs")
    |> assign(:hub, nil)
  end

  @impl true
  def handle_info({IotHubWeb.HubLive.FormComponent, {:saved, hub}}, socket) do
    {:noreply, stream_insert(socket, :hubs, hub)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    hub = Hubs.get_hub!(id)
    {:ok, _} = Hubs.delete_hub(hub)

    {:noreply, stream_delete(socket, :hubs, hub)}
  end
end
