defmodule IotHubWeb.CodecHubLive.Index do
  use IotHubWeb, :live_view

  alias IotHub.Hubs
  alias IotHub.Hubs.CodecHub

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :codecs_hubs, Hubs.list_codecs_hubs())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Codec hub")
    |> assign(:codec_hub, Hubs.get_codec_hub!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Codec hub")
    |> assign(:codec_hub, %CodecHub{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Codecs hubs")
    |> assign(:codec_hub, nil)
  end

  @impl true
  def handle_info({IotHubWeb.CodecHubLive.FormComponent, {:saved, codec_hub}}, socket) do
    {:noreply, stream_insert(socket, :codecs_hubs, codec_hub)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    codec_hub = Hubs.get_codec_hub!(id)
    {:ok, _} = Hubs.delete_codec_hub(codec_hub)

    {:noreply, stream_delete(socket, :codecs_hubs, codec_hub)}
  end
end
