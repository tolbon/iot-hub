defmodule IotHubWeb.DevicePropertyLiveTest do
  use IotHubWeb.ConnCase

  import Phoenix.LiveViewTest
  import IotHub.DevicesFixtures

  @create_attrs %{key: "some key", number_value: 120.5, value_type: "some value_type", string_value: "some string_value"}
  @update_attrs %{key: "some updated key", number_value: 456.7, value_type: "some updated value_type", string_value: "some updated string_value"}
  @invalid_attrs %{key: nil, number_value: nil, value_type: nil, string_value: nil}

  defp create_device_property(_) do
    device_property = device_property_fixture()
    %{device_property: device_property}
  end

  describe "Index" do
    setup [:create_device_property]

    test "lists all device_properties", %{conn: conn, device_property: device_property} do
      {:ok, _index_live, html} = live(conn, ~p"/device_properties")

      assert html =~ "Listing Device properties"
      assert html =~ device_property.key
    end

    test "saves new device_property", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/device_properties")

      assert index_live |> element("a", "New Device property") |> render_click() =~
               "New Device property"

      assert_patch(index_live, ~p"/device_properties/new")

      assert index_live
             |> form("#device_property-form", device_property: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#device_property-form", device_property: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/device_properties")

      html = render(index_live)
      assert html =~ "Device property created successfully"
      assert html =~ "some key"
    end

    test "updates device_property in listing", %{conn: conn, device_property: device_property} do
      {:ok, index_live, _html} = live(conn, ~p"/device_properties")

      assert index_live |> element("#device_properties-#{device_property.id} a", "Edit") |> render_click() =~
               "Edit Device property"

      assert_patch(index_live, ~p"/device_properties/#{device_property}/edit")

      assert index_live
             |> form("#device_property-form", device_property: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#device_property-form", device_property: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/device_properties")

      html = render(index_live)
      assert html =~ "Device property updated successfully"
      assert html =~ "some updated key"
    end

    test "deletes device_property in listing", %{conn: conn, device_property: device_property} do
      {:ok, index_live, _html} = live(conn, ~p"/device_properties")

      assert index_live |> element("#device_properties-#{device_property.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#device_properties-#{device_property.id}")
    end
  end

  describe "Show" do
    setup [:create_device_property]

    test "displays device_property", %{conn: conn, device_property: device_property} do
      {:ok, _show_live, html} = live(conn, ~p"/device_properties/#{device_property}")

      assert html =~ "Show Device property"
      assert html =~ device_property.key
    end

    test "updates device_property within modal", %{conn: conn, device_property: device_property} do
      {:ok, show_live, _html} = live(conn, ~p"/device_properties/#{device_property}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Device property"

      assert_patch(show_live, ~p"/device_properties/#{device_property}/show/edit")

      assert show_live
             |> form("#device_property-form", device_property: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#device_property-form", device_property: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/device_properties/#{device_property}")

      html = render(show_live)
      assert html =~ "Device property updated successfully"
      assert html =~ "some updated key"
    end
  end
end
