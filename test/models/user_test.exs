defmodule Ping.UserTest do
  use Ping.ModelCase

  alias Ping.User

  @valid_attrs %{country: "some content", avatar_url: "some content", 
   nickname: "some content", openid: "some content", 
   city: "some",
   province: "some content", gender: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
