defmodule IotHubWeb.UserHubLive.FormComponent do
  use IotHubWeb, :live_component

  alias IotHub.Hubs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage user_hub records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="user_hub-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save User hub</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{user_hub: user_hub} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Hubs.change_user_hub(user_hub))
     end)}
  end

  @impl true
  def handle_event("validate", %{"user_hub" => user_hub_params}, socket) do
    changeset = Hubs.change_user_hub(socket.assigns.user_hub, user_hub_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"user_hub" => user_hub_params}, socket) do
    save_user_hub(socket, socket.assigns.action, user_hub_params)
  end

  defp save_user_hub(socket, :edit, user_hub_params) do
    case Hubs.update_user_hub(socket.assigns.user_hub, user_hub_params) do
      {:ok, user_hub} ->
        notify_parent({:saved, user_hub})

        {:noreply,
         socket
         |> put_flash(:info, "User hub updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_user_hub(socket, :new, user_hub_params) do
    case Hubs.create_user_hub(user_hub_params) do
      {:ok, user_hub} ->
        notify_parent({:saved, user_hub})

        {:noreply,
         socket
         |> put_flash(:info, "User hub created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
