defmodule IotHubWeb.DeviceLive.Show do
  use IotHubWeb, :live_view

  alias IotHub.Devices

  @impl true
  def mount(params, _session, socket) do
    hub_id = params["hub_id"];
    {:ok, socket
    |> assign(:hub_id, hub_id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:device, Devices.get_device!(id))}
  end

  defp page_title(:show), do: "Show Device"
  defp page_title(:edit), do: "Edit Device"
end
