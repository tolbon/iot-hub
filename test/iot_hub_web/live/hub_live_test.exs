defmodule IotHubWeb.HubLiveTest do
  use IotHubWeb.ConnCase

  import Phoenix.LiveViewTest
  import IotHub.HubsFixtures

  @create_attrs %{enabled: true, name: "some name", broker_url: "some broker_url"}
  @update_attrs %{enabled: false, name: "some updated name", broker_url: "some updated broker_url"}
  @invalid_attrs %{enabled: false, name: nil, broker_url: nil}

  defp create_hub(_) do
    hub = hub_fixture()
    %{hub: hub}
  end

  describe "Index" do
    setup [:create_hub]

    test "lists all hubs", %{conn: conn, hub: hub} do
      {:ok, _index_live, html} = live(conn, ~p"/hubs")

      assert html =~ "Listing Hubs"
      assert html =~ hub.name
    end

    test "saves new hub", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/hubs")

      assert index_live |> element("a", "New Hub") |> render_click() =~
               "New Hub"

      assert_patch(index_live, ~p"/hubs/new")

      assert index_live
             |> form("#hub-form", hub: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#hub-form", hub: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/hubs")

      html = render(index_live)
      assert html =~ "Hub created successfully"
      assert html =~ "some name"
    end

    test "updates hub in listing", %{conn: conn, hub: hub} do
      {:ok, index_live, _html} = live(conn, ~p"/hubs")

      assert index_live |> element("#hubs-#{hub.id} a", "Edit") |> render_click() =~
               "Edit Hub"

      assert_patch(index_live, ~p"/hubs/#{hub}/edit")

      assert index_live
             |> form("#hub-form", hub: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#hub-form", hub: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/hubs")

      html = render(index_live)
      assert html =~ "Hub updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes hub in listing", %{conn: conn, hub: hub} do
      {:ok, index_live, _html} = live(conn, ~p"/hubs")

      assert index_live |> element("#hubs-#{hub.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#hubs-#{hub.id}")
    end
  end

  describe "Show" do
    setup [:create_hub]

    test "displays hub", %{conn: conn, hub: hub} do
      {:ok, _show_live, html} = live(conn, ~p"/hubs/#{hub}")

      assert html =~ "Show Hub"
      assert html =~ hub.name
    end

    test "updates hub within modal", %{conn: conn, hub: hub} do
      {:ok, show_live, _html} = live(conn, ~p"/hubs/#{hub}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Hub"

      assert_patch(show_live, ~p"/hubs/#{hub}/show/edit")

      assert show_live
             |> form("#hub-form", hub: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#hub-form", hub: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/hubs/#{hub}")

      html = render(show_live)
      assert html =~ "Hub updated successfully"
      assert html =~ "some updated name"
    end
  end
end
