defmodule IotHubWeb.DevicePropertyLive.Index do
  use IotHubWeb, :live_view

  alias IotHub.Devices
  alias IotHub.Devices.DeviceProperty

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :device_properties, Devices.list_device_properties())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Device property")
    |> assign(:device_property, Devices.get_device_property!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Device property")
    |> assign(:device_property, %DeviceProperty{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Device properties")
    |> assign(:device_property, nil)
  end

  @impl true
  def handle_info({IotHubWeb.DevicePropertyLive.FormComponent, {:saved, device_property}}, socket) do
    {:noreply, stream_insert(socket, :device_properties, device_property)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    device_property = Devices.get_device_property!(id)
    {:ok, _} = Devices.delete_device_property(device_property)

    {:noreply, stream_delete(socket, :device_properties, device_property)}
  end
end
