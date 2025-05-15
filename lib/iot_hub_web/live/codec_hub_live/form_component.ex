defmodule IotHubWeb.CodecHubLive.FormComponent do
  use IotHubWeb, :live_component

  alias IotHub.Hubs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage codec_hub records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="codec_hub-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Codec hub</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{codec_hub: codec_hub} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Hubs.change_codec_hub(codec_hub))
     end)}
  end

  @impl true
  def handle_event("validate", %{"codec_hub" => codec_hub_params}, socket) do
    changeset = Hubs.change_codec_hub(socket.assigns.codec_hub, codec_hub_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"codec_hub" => codec_hub_params}, socket) do
    save_codec_hub(socket, socket.assigns.action, codec_hub_params)
  end

  defp save_codec_hub(socket, :edit, codec_hub_params) do
    case Hubs.update_codec_hub(socket.assigns.codec_hub, codec_hub_params) do
      {:ok, codec_hub} ->
        notify_parent({:saved, codec_hub})

        {:noreply,
         socket
         |> put_flash(:info, "Codec hub updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_codec_hub(socket, :new, codec_hub_params) do
    case Hubs.create_codec_hub(codec_hub_params) do
      {:ok, codec_hub} ->
        notify_parent({:saved, codec_hub})

        {:noreply,
         socket
         |> put_flash(:info, "Codec hub created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
