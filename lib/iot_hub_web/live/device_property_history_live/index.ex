defmodule IotHubWeb.DevicePropertyHistoryLive.Index do
  use IotHubWeb, :live_view

  alias IotHub.Devices
  alias IotHub.Devices.DevicePropertyHistory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :device_properties_histories, Devices.list_device_properties_histories())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Device property history")
    |> assign(:device_property_history, Devices.get_device_property_history!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Device property history")
    |> assign(:device_property_history, %DevicePropertyHistory{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Device properties histories")
    |> assign(:device_property_history, nil)
  end

  @impl true
  def handle_info({IotHubWeb.DevicePropertyHistoryLive.FormComponent, {:saved, device_property_history}}, socket) do
    {:noreply, stream_insert(socket, :device_properties_histories, device_property_history)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    device_property_history = Devices.get_device_property_history!(id)
    {:ok, _} = Devices.delete_device_property_history(device_property_history)

    {:noreply, stream_delete(socket, :device_properties_histories, device_property_history)}
  end
end
