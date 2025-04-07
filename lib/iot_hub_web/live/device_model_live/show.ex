defmodule IotHubWeb.DeviceModelLive.Show do
  use IotHubWeb, :live_view

  alias IotHub.Devices

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:device_model, Devices.get_device_model!(id))}
  end

  defp page_title(:show), do: "Show Device model"
  defp page_title(:edit), do: "Edit Device model"
end
