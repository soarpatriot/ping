defmodule Ping.PostTest do
  use Ping.ModelCase

  alias Ping.Post

  @valid_attrs %{dream: "some content", progress: 42, reality: "some content", user_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Post.changeset(%Post{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Post.changeset(%Post{}, @invalid_attrs)
    refute changeset.valid?
  end
end
