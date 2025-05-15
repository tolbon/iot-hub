defmodule IotHubWeb.CodecLive.Index do
  use IotHubWeb, :live_view

  alias IotHub.Codecs
  alias IotHub.Codecs.Codec

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :codecs, Codecs.list_codecs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Codec")
    |> assign(:codec, Codecs.get_codec!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Codec")
    |> assign(:codec, %Codec{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Codecs")
    |> assign(:codec, nil)
  end

  @impl true
  def handle_info({IotHubWeb.CodecLive.FormComponent, {:saved, codec}}, socket) do
    {:noreply, stream_insert(socket, :codecs, codec)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    codec = Codecs.get_codec!(id)
    {:ok, _} = Codecs.delete_codec(codec)

    {:noreply, stream_delete(socket, :codecs, codec)}
  end
end
