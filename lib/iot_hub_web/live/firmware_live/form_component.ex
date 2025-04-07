defmodule IotHubWeb.FirmwareLive.FormComponent do
  use IotHubWeb, :live_component

  alias IotHub.Firmwares

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage firmware records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="firmware-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Firmware</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{firmware: firmware} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Firmwares.change_firmware(firmware))
     end)}
  end

  @impl true
  def handle_event("validate", %{"firmware" => firmware_params}, socket) do
    changeset = Firmwares.change_firmware(socket.assigns.firmware, firmware_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"firmware" => firmware_params}, socket) do
    save_firmware(socket, socket.assigns.action, firmware_params)
  end

  defp save_firmware(socket, :edit, firmware_params) do
    case Firmwares.update_firmware(socket.assigns.firmware, firmware_params) do
      {:ok, firmware} ->
        notify_parent({:saved, firmware})

        {:noreply,
         socket
         |> put_flash(:info, "Firmware updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_firmware(socket, :new, firmware_params) do
    case Firmwares.create_firmware(firmware_params) do
      {:ok, firmware} ->
        notify_parent({:saved, firmware})

        {:noreply,
         socket
         |> put_flash(:info, "Firmware created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
