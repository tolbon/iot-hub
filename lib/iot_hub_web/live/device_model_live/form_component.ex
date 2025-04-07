defmodule IotHubWeb.DeviceModelLive.FormComponent do
  use IotHubWeb, :live_component

  alias IotHub.Devices

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage device_model records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="device_model-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:version]} type="text" label="Version" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Device model</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{device_model: device_model} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Devices.change_device_model(device_model))
     end)}
  end

  @impl true
  def handle_event("validate", %{"device_model" => device_model_params}, socket) do
    changeset = Devices.change_device_model(socket.assigns.device_model, device_model_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"device_model" => device_model_params}, socket) do
    save_device_model(socket, socket.assigns.action, device_model_params)
  end

  defp save_device_model(socket, :edit, device_model_params) do
    case Devices.update_device_model(socket.assigns.device_model, device_model_params) do
      {:ok, device_model} ->
        notify_parent({:saved, device_model})

        {:noreply,
         socket
         |> put_flash(:info, "Device model updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_device_model(socket, :new, device_model_params) do
    case Devices.create_device_model(device_model_params) do
      {:ok, device_model} ->
        notify_parent({:saved, device_model})

        {:noreply,
         socket
         |> put_flash(:info, "Device model created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
