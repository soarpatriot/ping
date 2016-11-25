defmodule Ping.UserControllerTest do
  use Ping.ConnCase
  alias Ping.User
  @valid_attrs %{country: "some content", 
   avatar_url: "some content", 
    nickname: "some content", 
    openid: "some content", 
    province: "some content", 
    city: "some content", 
    gender: 1}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  #test "lists all entries on index", %{conn: conn} do
    
  #  conn = get conn, user_path(conn, :index)
  #  assert json_response(conn, 200)["data"] == []
  # end

  test "shows chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = get conn, user_path(conn, :show, user)
    assert json_response(conn, 200)["data"] == %{"id" => user.id,
      "openid" => user.openid,
      "nickname" => user.nickname,
      "gender" => user.gender,
      "province" => user.province,
      "city" => user.city,
      "country" => user.country,
      "avatar_url" => user.avatar_url}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, user_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :create),  @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, user_path(conn, :create), @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(User, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = put conn, user_path(conn, :update, user), user: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end
  
  test "insert or update user insert is valid", %{conn: conn} do
    conn = post conn, user_path(conn, :save_or_update), @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
  end
  test "insert or update user update is valid", %{conn: conn} do
    user =User.changeset(%User{}, @valid_attrs)
      |> Repo.insert! 
    conn = post conn, user_path(conn, :save_or_update), @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
  end



  test "deletes chosen resource", %{conn: conn} do
    user = Repo.insert! %User{}
    conn = delete conn, user_path(conn, :delete, user)
    assert response(conn, 204)
    refute Repo.get(User, user.id)
  end
end
