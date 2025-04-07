defmodule IotHubWeb.DevicePropertyHistoryLiveTest do
  use IotHubWeb.ConnCase

  import Phoenix.LiveViewTest
  import IotHub.DevicesFixtures

  @create_attrs %{key: "some key", number_value: 120.5, emission_at: "2025-04-03T21:05:00.000000Z", value_type: "some value_type", string_value: "some string_value"}
  @update_attrs %{key: "some updated key", number_value: 456.7, emission_at: "2025-04-04T21:05:00.000000Z", value_type: "some updated value_type", string_value: "some updated string_value"}
  @invalid_attrs %{key: nil, number_value: nil, emission_at: nil, value_type: nil, string_value: nil}

  defp create_device_property_history(_) do
    device_property_history = device_property_history_fixture()
    %{device_property_history: device_property_history}
  end

  describe "Index" do
    setup [:create_device_property_history]

    test "lists all device_properties_histories", %{conn: conn, device_property_history: device_property_history} do
      {:ok, _index_live, html} = live(conn, ~p"/device_properties_histories")

      assert html =~ "Listing Device properties histories"
      assert html =~ device_property_history.key
    end

    test "saves new device_property_history", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/device_properties_histories")

      assert index_live |> element("a", "New Device property history") |> render_click() =~
               "New Device property history"

      assert_patch(index_live, ~p"/device_properties_histories/new")

      assert index_live
             |> form("#device_property_history-form", device_property_history: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#device_property_history-form", device_property_history: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/device_properties_histories")

      html = render(index_live)
      assert html =~ "Device property history created successfully"
      assert html =~ "some key"
    end

    test "updates device_property_history in listing", %{conn: conn, device_property_history: device_property_history} do
      {:ok, index_live, _html} = live(conn, ~p"/device_properties_histories")

      assert index_live |> element("#device_properties_histories-#{device_property_history.id} a", "Edit") |> render_click() =~
               "Edit Device property history"

      assert_patch(index_live, ~p"/device_properties_histories/#{device_property_history}/edit")

      assert index_live
             |> form("#device_property_history-form", device_property_history: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#device_property_history-form", device_property_history: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/device_properties_histories")

      html = render(index_live)
      assert html =~ "Device property history updated successfully"
      assert html =~ "some updated key"
    end

    test "deletes device_property_history in listing", %{conn: conn, device_property_history: device_property_history} do
      {:ok, index_live, _html} = live(conn, ~p"/device_properties_histories")

      assert index_live |> element("#device_properties_histories-#{device_property_history.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#device_properties_histories-#{device_property_history.id}")
    end
  end

  describe "Show" do
    setup [:create_device_property_history]

    test "displays device_property_history", %{conn: conn, device_property_history: device_property_history} do
      {:ok, _show_live, html} = live(conn, ~p"/device_properties_histories/#{device_property_history}")

      assert html =~ "Show Device property history"
      assert html =~ device_property_history.key
    end

    test "updates device_property_history within modal", %{conn: conn, device_property_history: device_property_history} do
      {:ok, show_live, _html} = live(conn, ~p"/device_properties_histories/#{device_property_history}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Device property history"

      assert_patch(show_live, ~p"/device_properties_histories/#{device_property_history}/show/edit")

      assert show_live
             |> form("#device_property_history-form", device_property_history: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#device_property_history-form", device_property_history: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/device_properties_histories/#{device_property_history}")

      html = render(show_live)
      assert html =~ "Device property history updated successfully"
      assert html =~ "some updated key"
    end
  end
end
