defmodule IotHubWeb.UserHubLive.Show do
  use IotHubWeb, :live_view

  alias IotHub.Hubs

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:user_hub, Hubs.get_user_hub!(id))}
  end

  defp page_title(:show), do: "Show User hub"
  defp page_title(:edit), do: "Edit User hub"
end
