defmodule IotHubWeb.Api.Devices.DeviceActionController do
  use IotHubWeb, :controller
  require Logger

  action_fallback IotHubWeb.FallbackController

  def action_call(conn, %{"hub_name" => hub_name, "device_id" => device_id, "action_name" => action_name}) do
    data = conn.body_params

    hub = IotHub.Hubs.get_hub_by_name!(hub_name)
    case IotHub.Devices.get_device_model_by_device!(device_id, hub.id) do
      device ->
        wot_schema_decoded = device.firmware.device_model.schema
        action_input = wot_schema_decoded
                      |>Map.get("actions")
                      |>Map.get(action_name)
                      |>Map.get("input")
        case action_input do
          nil ->
            Logger.warning("Failed to get action input.")
            conn
            |> put_status(:bad_request)
            |> json(%{error: "Invalid payload "})
          _ -> nil
        end
        xema_schema = action_input |> JsonXema.new();
        # Valid le payload et event schema en JSON Schema
        if JsonXema.valid?(xema_schema, data) == false do
          conn
          |> put_status(:bad_request)
          |> json(%{error: "Invalid payload"})
        end

        form_0 = wot_schema_decoded
                      |>Map.get("actions")
                      |>Map.get(action_name)
                      |>Map.get("forms")
                      |> case do
                        nil -> nil
                        forms when is_list(forms) -> Enum.at(forms, 0)
                        end

        data_encoded = encodingData(form_0, data);
        if Map.get(device, :connected, false) do
          if conn.query_params["async"] == "true" do
            IotHub.Worker.SenderAction.publish(hub_name <> ".d." <> device_id <>".action." <> action_name, data_encoded)

            conn
            |> put_status(:accepted)
            |> json(%{})
          else
            IotHub.Worker.SenderAction.publish(hub_name <> ".d." <> device_id <>".action." <> action_name, data_encoded)

            conn
            |> put_status(:ok)
            |> json(%{})
          end
        else
          conn
            |> put_status(:bad_request)
            |> json(%{error: "Device is not connected"})
        end
    end
  end


  def encodingData(form, data) do
    form
    |> Map.get("contentType")
    |> case do
      "application/json" ->
        JSON.encode!(data)
      _ ->
        JSON.encode!(data)
    end
  end

  def flatten_map(map, parent_key \\ "", acc \\ %{}) do
    Enum.reduce(map, acc, fn {key, value}, acc ->
      full_key = if parent_key == "", do: key, else: "#{parent_key}.#{key}"
      case value do
        %{} -> flatten_map(value, full_key, acc)
        _ -> Map.put(acc, full_key, value)
      end
    end)
  end
end
