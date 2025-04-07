defmodule IotHubWeb.DevicePropertyLive.Show do
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
     |> assign(:device_property, Devices.get_device_property!(id))}
  end

  defp page_title(:show), do: "Show Device property"
  defp page_title(:edit), do: "Edit Device property"
end
