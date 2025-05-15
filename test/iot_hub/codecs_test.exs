defmodule IotHub.CodecsTest do
  use IotHub.DataCase

  alias IotHub.Codecs

  describe "codecs" do
    alias IotHub.Codecs.Codec

    import IotHub.CodecsFixtures

    @invalid_attrs %{name: nil, source: nil, code_or_path: nil}

    test "list_codecs/0 returns all codecs" do
      codec = codec_fixture()
      assert Codecs.list_codecs() == [codec]
    end

    test "get_codec!/1 returns the codec with given id" do
      codec = codec_fixture()
      assert Codecs.get_codec!(codec.id) == codec
    end

    test "create_codec/1 with valid data creates a codec" do
      valid_attrs = %{name: "some name", source: :wasm_inline, code_or_path: "some code_or_path"}

      assert {:ok, %Codec{} = codec} = Codecs.create_codec(valid_attrs)
      assert codec.name == "some name"
      assert codec.source == :wasm_inline
      assert codec.code_or_path == "some code_or_path"
    end

    test "create_codec/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Codecs.create_codec(@invalid_attrs)
    end

    test "update_codec/2 with valid data updates the codec" do
      codec = codec_fixture()
      update_attrs = %{name: "some updated name", source: :s3, code_or_path: "some updated code_or_path"}

      assert {:ok, %Codec{} = codec} = Codecs.update_codec(codec, update_attrs)
      assert codec.name == "some updated name"
      assert codec.source == :s3
      assert codec.code_or_path == "some updated code_or_path"
    end

    test "update_codec/2 with invalid data returns error changeset" do
      codec = codec_fixture()
      assert {:error, %Ecto.Changeset{}} = Codecs.update_codec(codec, @invalid_attrs)
      assert codec == Codecs.get_codec!(codec.id)
    end

    test "delete_codec/1 deletes the codec" do
      codec = codec_fixture()
      assert {:ok, %Codec{}} = Codecs.delete_codec(codec)
      assert_raise Ecto.NoResultsError, fn -> Codecs.get_codec!(codec.id) end
    end

    test "change_codec/1 returns a codec changeset" do
      codec = codec_fixture()
      assert %Ecto.Changeset{} = Codecs.change_codec(codec)
    end
  end
end
