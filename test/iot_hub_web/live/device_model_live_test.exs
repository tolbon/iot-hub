defmodule IotHubWeb.DeviceModelLiveTest do
  use IotHubWeb.ConnCase

  import Phoenix.LiveViewTest
  import IotHub.DevicesFixtures

  @create_attrs %{name: "some name", version: "some version", schema: %{}}
  @update_attrs %{name: "some updated name", version: "some updated version", schema: %{}}
  @invalid_attrs %{name: nil, version: nil, schema: nil}

  defp create_device_model(_) do
    device_model = device_model_fixture()
    %{device_model: device_model}
  end

  describe "Index" do
    setup [:create_device_model]

    test "lists all device_models", %{conn: conn, device_model: device_model} do
      {:ok, _index_live, html} = live(conn, ~p"/device_models")

      assert html =~ "Listing Device models"
      assert html =~ device_model.name
    end

    test "saves new device_model", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/device_models")

      assert index_live |> element("a", "New Device model") |> render_click() =~
               "New Device model"

      assert_patch(index_live, ~p"/device_models/new")

      assert index_live
             |> form("#device_model-form", device_model: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#device_model-form", device_model: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/device_models")

      html = render(index_live)
      assert html =~ "Device model created successfully"
      assert html =~ "some name"
    end

    test "updates device_model in listing", %{conn: conn, device_model: device_model} do
      {:ok, index_live, _html} = live(conn, ~p"/device_models")

      assert index_live |> element("#device_models-#{device_model.id} a", "Edit") |> render_click() =~
               "Edit Device model"

      assert_patch(index_live, ~p"/device_models/#{device_model}/edit")

      assert index_live
             |> form("#device_model-form", device_model: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#device_model-form", device_model: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/device_models")

      html = render(index_live)
      assert html =~ "Device model updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes device_model in listing", %{conn: conn, device_model: device_model} do
      {:ok, index_live, _html} = live(conn, ~p"/device_models")

      assert index_live |> element("#device_models-#{device_model.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#device_models-#{device_model.id}")
    end
  end

  describe "Show" do
    setup [:create_device_model]

    test "displays device_model", %{conn: conn, device_model: device_model} do
      {:ok, _show_live, html} = live(conn, ~p"/device_models/#{device_model}")

      assert html =~ "Show Device model"
      assert html =~ device_model.name
    end

    test "updates device_model within modal", %{conn: conn, device_model: device_model} do
      {:ok, show_live, _html} = live(conn, ~p"/device_models/#{device_model}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Device model"

      assert_patch(show_live, ~p"/device_models/#{device_model}/show/edit")

      assert show_live
             |> form("#device_model-form", device_model: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#device_model-form", device_model: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/device_models/#{device_model}")

      html = render(show_live)
      assert html =~ "Device model updated successfully"
      assert html =~ "some updated name"
    end
  end
end
