defmodule IotHubWeb.UserHubLiveTest do
  use IotHubWeb.ConnCase

  import Phoenix.LiveViewTest
  import IotHub.HubsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_user_hub(_) do
    user_hub = user_hub_fixture()
    %{user_hub: user_hub}
  end

  describe "Index" do
    setup [:create_user_hub]

    test "lists all users_hubs", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/users_hubs")

      assert html =~ "Listing Users hubs"
    end

    test "saves new user_hub", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/users_hubs")

      assert index_live |> element("a", "New User hub") |> render_click() =~
               "New User hub"

      assert_patch(index_live, ~p"/admin/users_hubs/new")

      assert index_live
             |> form("#user_hub-form", user_hub: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_hub-form", user_hub: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/users_hubs")

      html = render(index_live)
      assert html =~ "User hub created successfully"
    end

    test "updates user_hub in listing", %{conn: conn, user_hub: user_hub} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/users_hubs")

      assert index_live |> element("#users_hubs-#{user_hub.id} a", "Edit") |> render_click() =~
               "Edit User hub"

      assert_patch(index_live, ~p"/admin/users_hubs/#{user_hub}/edit")

      assert index_live
             |> form("#user_hub-form", user_hub: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#user_hub-form", user_hub: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/admin/users_hubs")

      html = render(index_live)
      assert html =~ "User hub updated successfully"
    end

    test "deletes user_hub in listing", %{conn: conn, user_hub: user_hub} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/users_hubs")

      assert index_live |> element("#users_hubs-#{user_hub.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#users_hubs-#{user_hub.id}")
    end
  end

  describe "Show" do
    setup [:create_user_hub]

    test "displays user_hub", %{conn: conn, user_hub: user_hub} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/users_hubs/#{user_hub}")

      assert html =~ "Show User hub"
    end

    test "updates user_hub within modal", %{conn: conn, user_hub: user_hub} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/users_hubs/#{user_hub}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit User hub"

      assert_patch(show_live, ~p"/admin/users_hubs/#{user_hub}/show/edit")

      assert show_live
             |> form("#user_hub-form", user_hub: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#user_hub-form", user_hub: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/admin/users_hubs/#{user_hub}")

      html = render(show_live)
      assert html =~ "User hub updated successfully"
    end
  end
end
