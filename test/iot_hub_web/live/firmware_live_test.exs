defmodule IotHubWeb.FirmwareLiveTest do
  use IotHubWeb.ConnCase

  import Phoenix.LiveViewTest
  import IotHub.FirmwaresFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_firmware(_) do
    firmware = firmware_fixture()
    %{firmware: firmware}
  end

  describe "Index" do
    setup [:create_firmware]

    test "lists all firmwares", %{conn: conn, firmware: firmware} do
      {:ok, _index_live, html} = live(conn, ~p"/hubs/#{hub}/firmwares")

      assert html =~ "Listing Firmwares"
      assert html =~ firmware.name
    end

    test "saves new firmware", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/hubs/#{hub}/firmwares")

      assert index_live |> element("a", "New Firmware") |> render_click() =~
               "New Firmware"

      assert_patch(index_live, ~p"/hubs/#{hub}/firmwares/new")

      assert index_live
             |> form("#firmware-form", firmware: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#firmware-form", firmware: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/hubs/#{hub}/firmwares")

      html = render(index_live)
      assert html =~ "Firmware created successfully"
      assert html =~ "some name"
    end

    test "updates firmware in listing", %{conn: conn, firmware: firmware} do
      {:ok, index_live, _html} = live(conn, ~p"/hubs/#{hub}/firmwares")

      assert index_live |> element("#firmwares-#{firmware.id} a", "Edit") |> render_click() =~
               "Edit Firmware"

      assert_patch(index_live, ~p"/hubs/#{hub}/firmwares/#{firmware}/edit")

      assert index_live
             |> form("#firmware-form", firmware: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#firmware-form", firmware: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/hubs/#{hub}/firmwares")

      html = render(index_live)
      assert html =~ "Firmware updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes firmware in listing", %{conn: conn, firmware: firmware} do
      {:ok, index_live, _html} = live(conn, ~p"/hubs/#{hub}/firmwares")

      assert index_live |> element("#firmwares-#{firmware.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#firmwares-#{firmware.id}")
    end
  end

  describe "Show" do
    setup [:create_firmware]

    test "displays firmware", %{conn: conn, firmware: firmware} do
      {:ok, _show_live, html} = live(conn, ~p"/hubs/#{hub}/firmwares/#{firmware}")

      assert html =~ "Show Firmware"
      assert html =~ firmware.name
    end

    test "updates firmware within modal", %{conn: conn, firmware: firmware} do
      {:ok, show_live, _html} = live(conn, ~p"/hubs/#{hub}/firmwares/#{firmware}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Firmware"

      assert_patch(show_live, ~p"/hubs/#{hub}/firmwares/#{firmware}/show/edit")

      assert show_live
             |> form("#firmware-form", firmware: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#firmware-form", firmware: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/hubs/#{hub}/firmwares/#{firmware}")

      html = render(show_live)
      assert html =~ "Firmware updated successfully"
      assert html =~ "some updated name"
    end
  end
end
