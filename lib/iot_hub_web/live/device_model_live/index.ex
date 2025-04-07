defmodule IotHubWeb.DeviceModelLive.Index do
  use IotHubWeb, :live_view

  alias IotHub.Devices
  alias IotHub.Devices.DeviceModel

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :device_models, Devices.list_device_models())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Device model")
    |> assign(:device_model, Devices.get_device_model!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Device model")
    |> assign(:device_model, %DeviceModel{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Device models")
    |> assign(:device_model, nil)
  end

  @impl true
  def handle_info({IotHubWeb.DeviceModelLive.FormComponent, {:saved, device_model}}, socket) do
    {:noreply, stream_insert(socket, :device_models, device_model)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    device_model = Devices.get_device_model!(id)
    {:ok, _} = Devices.delete_device_model(device_model)

    {:noreply, stream_delete(socket, :device_models, device_model)}
  end
end
