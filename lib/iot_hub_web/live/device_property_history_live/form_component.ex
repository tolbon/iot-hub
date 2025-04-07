defmodule IotHubWeb.DevicePropertyHistoryLive.FormComponent do
  use IotHubWeb, :live_component

  alias IotHub.Devices

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage device_property_history records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="device_property_history-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:emission_at]} type="text" label="Emission at" />
        <.input field={@form[:key]} type="text" label="Key" />
        <.input field={@form[:value_type]} type="text" label="Value type" />
        <.input field={@form[:string_value]} type="text" label="String value" />
        <.input field={@form[:number_value]} type="number" label="Number value" step="any" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Device property history</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{device_property_history: device_property_history} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Devices.change_device_property_history(device_property_history))
     end)}
  end

  @impl true
  def handle_event("validate", %{"device_property_history" => device_property_history_params}, socket) do
    changeset = Devices.change_device_property_history(socket.assigns.device_property_history, device_property_history_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"device_property_history" => device_property_history_params}, socket) do
    save_device_property_history(socket, socket.assigns.action, device_property_history_params)
  end

  defp save_device_property_history(socket, :edit, device_property_history_params) do
    case Devices.update_device_property_history(socket.assigns.device_property_history, device_property_history_params) do
      {:ok, device_property_history} ->
        notify_parent({:saved, device_property_history})

        {:noreply,
         socket
         |> put_flash(:info, "Device property history updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_device_property_history(socket, :new, device_property_history_params) do
    case Devices.create_device_property_history(device_property_history_params) do
      {:ok, device_property_history} ->
        notify_parent({:saved, device_property_history})

        {:noreply,
         socket
         |> put_flash(:info, "Device property history created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
