defmodule IotHubWeb.HubLive.FormComponent do
  use IotHubWeb, :live_component

  alias IotHub.Hubs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage hub records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="hub-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:enabled]} type="checkbox" label="Enabled" />
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:broker_url]} type="text" label="Broker url" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Hub</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{hub: hub} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Hubs.change_hub(hub))
     end)}
  end

  @impl true
  def handle_event("validate", %{"hub" => hub_params}, socket) do
    changeset = Hubs.change_hub(socket.assigns.hub, hub_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"hub" => hub_params}, socket) do
    save_hub(socket, socket.assigns.action, hub_params)
  end

  defp save_hub(socket, :edit, hub_params) do
    case Hubs.update_hub(socket.assigns.hub, hub_params) do
      {:ok, hub} ->
        notify_parent({:saved, hub})

        {:noreply,
         socket
         |> put_flash(:info, "Hub updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_hub(socket, :new, hub_params) do
    case Hubs.create_hub(hub_params) do
      {:ok, hub} ->
        notify_parent({:saved, hub})

        {:noreply,
         socket
         |> put_flash(:info, "Hub created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
