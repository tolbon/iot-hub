defmodule IotHubWeb.FirmwareLive.Index do
  use IotHubWeb, :live_view

  alias IotHub.Firmwares
  alias IotHub.Firmwares.Firmware

  @impl true
  def mount(params, _session, socket) do
    hub_id = params["hub_id"];

    {:ok, stream(socket, :firmwares, Firmwares.list_firmwares_in_hub(hub_id))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Firmware")
    |> assign(:firmware, Firmwares.get_firmware!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Firmware")
    |> assign(:firmware, %Firmware{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Firmwares")
    |> assign(:firmware, nil)
  end

  @impl true
  def handle_info({IotHubWeb.FirmwareLive.FormComponent, {:saved, firmware}}, socket) do
    {:noreply, stream_insert(socket, :firmwares, firmware)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    firmware = Firmwares.get_firmware!(id)
    {:ok, _} = Firmwares.delete_firmware(firmware)

    {:noreply, stream_delete(socket, :firmwares, firmware)}
  end
end
