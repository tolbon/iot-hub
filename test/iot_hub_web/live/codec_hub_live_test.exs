defmodule IotHubWeb.CodecHubLiveTest do
  use IotHubWeb.ConnCase

  import Phoenix.LiveViewTest
  import IotHub.HubsFixtures

  @create_attrs %{}
  @update_attrs %{}
  @invalid_attrs %{}

  defp create_codec_hub(_) do
    codec_hub = codec_hub_fixture()
    %{codec_hub: codec_hub}
  end

  describe "Index" do
    setup [:create_codec_hub]

    test "lists all codecs_hubs", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/codecs_hubs")

      assert html =~ "Listing Codecs hubs"
    end

    test "saves new codec_hub", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/codecs_hubs")

      assert index_live |> element("a", "New Codec hub") |> render_click() =~
               "New Codec hub"

      assert_patch(index_live, ~p"/codecs_hubs/new")

      assert index_live
             |> form("#codec_hub-form", codec_hub: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#codec_hub-form", codec_hub: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/codecs_hubs")

      html = render(index_live)
      assert html =~ "Codec hub created successfully"
    end

    test "updates codec_hub in listing", %{conn: conn, codec_hub: codec_hub} do
      {:ok, index_live, _html} = live(conn, ~p"/codecs_hubs")

      assert index_live |> element("#codecs_hubs-#{codec_hub.id} a", "Edit") |> render_click() =~
               "Edit Codec hub"

      assert_patch(index_live, ~p"/codecs_hubs/#{codec_hub}/edit")

      assert index_live
             |> form("#codec_hub-form", codec_hub: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#codec_hub-form", codec_hub: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/codecs_hubs")

      html = render(index_live)
      assert html =~ "Codec hub updated successfully"
    end

    test "deletes codec_hub in listing", %{conn: conn, codec_hub: codec_hub} do
      {:ok, index_live, _html} = live(conn, ~p"/codecs_hubs")

      assert index_live |> element("#codecs_hubs-#{codec_hub.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#codecs_hubs-#{codec_hub.id}")
    end
  end

  describe "Show" do
    setup [:create_codec_hub]

    test "displays codec_hub", %{conn: conn, codec_hub: codec_hub} do
      {:ok, _show_live, html} = live(conn, ~p"/codecs_hubs/#{codec_hub}")

      assert html =~ "Show Codec hub"
    end

    test "updates codec_hub within modal", %{conn: conn, codec_hub: codec_hub} do
      {:ok, show_live, _html} = live(conn, ~p"/codecs_hubs/#{codec_hub}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Codec hub"

      assert_patch(show_live, ~p"/codecs_hubs/#{codec_hub}/show/edit")

      assert show_live
             |> form("#codec_hub-form", codec_hub: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#codec_hub-form", codec_hub: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/codecs_hubs/#{codec_hub}")

      html = render(show_live)
      assert html =~ "Codec hub updated successfully"
    end
  end
end
