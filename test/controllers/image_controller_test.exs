defmodule Ping.ImageControllerTest do
  use Ping.ConnCase

  alias Ping.Image
  @valid_attrs %{hash: "some content", key: "some content", url: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, image_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    image = Repo.insert! %Image{}
    conn = get conn, image_path(conn, :show, image)
    assert json_response(conn, 200)["data"] == %{"id" => image.id,
      "key" => image.key,
      "hash" => image.hash,
      "url" => image.url,
      "post_id" => image.post_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, image_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, image_path(conn, :create), image: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Image, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, image_path(conn, :create), image: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    image = Repo.insert! %Image{}
    conn = put conn, image_path(conn, :update, image), image: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Image, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    image = Repo.insert! %Image{}
    conn = put conn, image_path(conn, :update, image), image: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    image = Repo.insert! %Image{}
    conn = delete conn, image_path(conn, :delete, image)
    assert response(conn, 204)
    refute Repo.get(Image, image.id)
  end
end
