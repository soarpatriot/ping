defmodule Ping.ImageTest do
  use Ping.ModelCase

  alias Ping.Image

  @valid_attrs %{hash: "some content", key: "some content", url: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Image.changeset(%Image{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Image.changeset(%Image{}, @invalid_attrs)
    refute changeset.valid?
  end
end
