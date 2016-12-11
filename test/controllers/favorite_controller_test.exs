defmodule Ping.FavoriteControllerTest do
  use Ping.ConnCase

  alias Ping.Favorite
  alias Ping.Post
  require IEx
  @valid_attrs %{post_id: 42, user_id: 42 }
  @valid_post_attrs %{dream: "some content", progress: 42, reality: "some content", user_id: 42, count: 3 }
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, favorite_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    favorite = Repo.insert! %Favorite{}
    conn = get conn, favorite_path(conn, :show, favorite)
    assert json_response(conn, 200)["data"] == %{"id" => favorite.id,
      "user_id" => favorite.user_id,
      "post_id" => favorite.post_id }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, favorite_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, favorite_path(conn, :create), favorite: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Favorite, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, favorite_path(conn, :create), favorite: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    favorite = Repo.insert! %Favorite{}
    conn = put conn, favorite_path(conn, :update, favorite), favorite: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Favorite, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    favorite = Repo.insert! %Favorite{}
    conn = put conn, favorite_path(conn, :update, favorite), favorite: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    favorite = Repo.insert! %Favorite{}
    conn = delete conn, favorite_path(conn, :delete, favorite)
    assert response(conn, 204)
    refute Repo.get(Favorite, favorite.id)
  end

  test "up with up action", %{conn: conn} do 
    changeset = Post.changeset(%Post{}, @valid_post_attrs) 
    post = Repo.insert! changeset
    ch = Map.merge(@valid_attrs, %{post_id: post.id})
 
    conn = post conn, favorite_path(conn, :up), favorite: ch
    assert json_response(conn, 201)["data"] == %{"post_id" => post.id,
      "count" => post.count + 1 }

    # assert Repo.get_by(Favorite, @valid_attrs)
    
  end 
  test "up with down action", %{conn: conn} do 
    changeset = Post.changeset(%Post{}, @valid_post_attrs) 
    post = Repo.insert! changeset
    ch = Map.merge(@valid_attrs, %{post_id: post.id})
    fav_changeset = Favorite.changeset(%Favorite{}, ch)     
    Repo.insert! fav_changeset
    conn = post conn, favorite_path(conn, :up), favorite: ch
    assert json_response(conn, 201)["data"] == %{"post_id" => post.id,
      "count" => post.count - 1 }

    # assert Repo.get_by(Favorite, @valid_attrs)
    
  end 
end
