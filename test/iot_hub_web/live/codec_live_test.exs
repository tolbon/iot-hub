defmodule IotHubWeb.CodecLiveTest do
  use IotHubWeb.ConnCase

  import Phoenix.LiveViewTest
  import IotHub.CodecsFixtures

  @create_attrs %{name: "some name", source: :wasm_inline, code_or_path: "some code_or_path"}
  @update_attrs %{name: "some updated name", source: :s3, code_or_path: "some updated code_or_path"}
  @invalid_attrs %{name: nil, source: nil, code_or_path: nil}

  defp create_codec(_) do
    codec = codec_fixture()
    %{codec: codec}
  end

  describe "Index" do
    setup [:create_codec]

    test "lists all codecs", %{conn: conn, codec: codec} do
      {:ok, _index_live, html} = live(conn, ~p"/codecs")

      assert html =~ "Listing Codecs"
      assert html =~ codec.name
    end

    test "saves new codec", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/codecs")

      assert index_live |> element("a", "New Codec") |> render_click() =~
               "New Codec"

      assert_patch(index_live, ~p"/codecs/new")

      assert index_live
             |> form("#codec-form", codec: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#codec-form", codec: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/codecs")

      html = render(index_live)
      assert html =~ "Codec created successfully"
      assert html =~ "some name"
    end

    test "updates codec in listing", %{conn: conn, codec: codec} do
      {:ok, index_live, _html} = live(conn, ~p"/codecs")

      assert index_live |> element("#codecs-#{codec.id} a", "Edit") |> render_click() =~
               "Edit Codec"

      assert_patch(index_live, ~p"/codecs/#{codec}/edit")

      assert index_live
             |> form("#codec-form", codec: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#codec-form", codec: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/codecs")

      html = render(index_live)
      assert html =~ "Codec updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes codec in listing", %{conn: conn, codec: codec} do
      {:ok, index_live, _html} = live(conn, ~p"/codecs")

      assert index_live |> element("#codecs-#{codec.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#codecs-#{codec.id}")
    end
  end

  describe "Show" do
    setup [:create_codec]

    test "displays codec", %{conn: conn, codec: codec} do
      {:ok, _show_live, html} = live(conn, ~p"/codecs/#{codec}")

      assert html =~ "Show Codec"
      assert html =~ codec.name
    end

    test "updates codec within modal", %{conn: conn, codec: codec} do
      {:ok, show_live, _html} = live(conn, ~p"/codecs/#{codec}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Codec"

      assert_patch(show_live, ~p"/codecs/#{codec}/show/edit")

      assert show_live
             |> form("#codec-form", codec: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#codec-form", codec: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/codecs/#{codec}")

      html = render(show_live)
      assert html =~ "Codec updated successfully"
      assert html =~ "some updated name"
    end
  end
end
