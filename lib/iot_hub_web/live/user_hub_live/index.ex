defmodule IotHubWeb.UserHubLive.Index do
  use IotHubWeb, :live_view

  alias IotHub.Hubs
  alias IotHub.Hubs.UserHub

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :users_hubs, Hubs.list_users_hubs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit User hub")
    |> assign(:user_hub, Hubs.get_user_hub!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New User hub")
    |> assign(:user_hub, %UserHub{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Users hubs")
    |> assign(:user_hub, nil)
  end

  @impl true
  def handle_info({IotHubWeb.UserHubLive.FormComponent, {:saved, user_hub}}, socket) do
    {:noreply, stream_insert(socket, :users_hubs, user_hub)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    user_hub = Hubs.get_user_hub!(id)
    {:ok, _} = Hubs.delete_user_hub(user_hub)

    {:noreply, stream_delete(socket, :users_hubs, user_hub)}
  end
end
