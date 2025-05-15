defmodule IotHubWeb.CodecLive.FormComponent do
  use IotHubWeb, :live_component

  alias IotHub.Codecs

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        {@title}
        <:subtitle>Use this form to manage codec records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="codec-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input
          field={@form[:source]}
          type="select"
          label="Source"
          prompt="Choose a value"
          options={Ecto.Enum.values(IotHub.Codecs.Codec, :source)}
        />
        <.input field={@form[:code_or_path]} type="text" label="Code or path" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Codec</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{codec: codec} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
     |> assign_new(:form, fn ->
       to_form(Codecs.change_codec(codec))
     end)}
  end

  @impl true
  def handle_event("validate", %{"codec" => codec_params}, socket) do
    changeset = Codecs.change_codec(socket.assigns.codec, codec_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"codec" => codec_params}, socket) do
    save_codec(socket, socket.assigns.action, codec_params)
  end

  defp save_codec(socket, :edit, codec_params) do
    case Codecs.update_codec(socket.assigns.codec, codec_params) do
      {:ok, codec} ->
        notify_parent({:saved, codec})

        {:noreply,
         socket
         |> put_flash(:info, "Codec updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_codec(socket, :new, codec_params) do
    case Codecs.create_codec(codec_params) do
      {:ok, codec} ->
        notify_parent({:saved, codec})

        {:noreply,
         socket
         |> put_flash(:info, "Codec created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
