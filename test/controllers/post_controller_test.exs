defmodule Ping.PostControllerTest do
  use Ping.ConnCase

  alias Ping.Post
  alias Ping.User
  alias Ping.Favorite
  alias Ping.Comment
  
  import Ping.Factory
  # @valid_attrs %{dream: "some content", progress: 42, reality: "some content", user_id: 1, count: 3 , favorite: false}
  @valid_attrs %{dream: "some content", user_id: 1, count: 3 , favorite: false}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end
  
  test "page the empty list ", %{conn: conn} do 
    conn = get conn, post_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end
  test "page the not empty list", %{conn: conn} do 
    user =  Repo.insert! User.changeset(%User{}, %{nickname: "121", avatar_url: "http://www.a/b.jpg", openid: "12213"})
    changeset = Post.changeset(%Post{}, @valid_attrs) 
                |> Ecto.Changeset.put_change(:user_id, user.id)
    Repo.insert! changeset
    conn = get conn, post_path(conn, :index)
    post = hd(json_response(conn,200)["data"])
    #IO.inspect  post
    assert  %{"id" => post["id"],
      "dream" => post["dream"],
      "reality" => post["reality"],
      "progress" => post["progress"],
      "user_id" => user.id,
      "nickname" => user.nickname,
      "avatar_url" => user.avatar_url
       }

  end
 
  test "lists all entries on index", %{conn: conn} do
    conn = get conn, post_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    user =  Repo.insert! User.changeset(%User{}, %{nickname: "121", avatar_url: "http://www.a/b.jpg", openid: "12213"})
    changeset = Post.changeset(%Post{}, @valid_attrs) 
                |> Ecto.Changeset.put_change(:user_id, user.id)
    post = Repo.insert! changeset
    insert(:favorite, user: user, post: post)
    comment = Repo.insert! Comment.changeset(%Comment{}, %{user_id: user.id, post_id: post.id, content: "11"})
    conn = get conn, post_path(conn, :show, post), user_id: user.id

    assert json_response(conn, 200) == %{"id" => post.id,
      "dream" => post.dream,
      "reality" => post.reality,
      "progress" => post.progress,
      "count" => post.count,
      "user_id" => user.id,
      "gender" => user.gender, 
      "nickname" => user.nickname,
      "avatar_url" => user.avatar_url,
      "favorited" => true,
      "published_at" => Post.time_ago_unit(post),
      "comments" => [%{
        "id" => comment.id,
        "post_id"=> post.id,
        "user_id" => user.id,
        "content" => comment.content,
        "gender" => user.gender,
        "nickname" => user.nickname,
        "avatar_url" => user.avatar_url,
        "published_at" => Post.time_ago_unit(comment),
      }]
    }
  end

  test "list favorited chosen resource", %{conn: conn} do
    user =  Repo.insert! User.changeset(%User{}, %{nickname: "121", avatar_url: "http://www.a/b.jpg", openid: "12213"})
    changeset = Post.changeset(%Post{}, @valid_attrs) 
                |> Ecto.Changeset.put_change(:user_id, user.id)
    post = Repo.insert! changeset
    
    Favorite.changeset(%Favorite{}, %{user_id: user.id, post_id: post.id}) 
    |> Repo.insert 
    conn = get conn, post_path(conn, :index, %{user_id: user.id })
    
    assert hd(json_response(conn, 200)["data"]) == %{"id" => post.id,
      "dream" => post.dream,
      "reality" => post.reality,
      "progress" => post.progress,
      "count" => post.count,
      "user_id" => user.id,
      "gender" => user.gender, 
      "nickname" => user.nickname,
      "avatar_url" => user.avatar_url,
      "favorited" => true,
      "published_at" => Post.time_ago_unit(post)
    }
  end

  test "list unfavorited chosen resource", %{conn: conn} do
    user =  Repo.insert! User.changeset(%User{}, %{nickname: "121", avatar_url: "http://www.a/b.jpg", openid: "12213"})
    changeset = Post.changeset(%Post{}, @valid_attrs) 
                |> Ecto.Changeset.put_change(:user_id, user.id)
    post = Repo.insert! changeset
    
    conn = get conn, post_path(conn, :index, %{user_id: user.id })
    
    assert hd(json_response(conn, 200)["data"]) == %{"id" => post.id,
      "dream" => post.dream,
      "reality" => post.reality,
      "progress" => post.progress,
      "count" => post.count,
      "user_id" => user.id,
      "gender" => user.gender, 
      "nickname" => user.nickname,
      "avatar_url" => user.avatar_url,
      "favorited" => false,
      "published_at" => Post.time_ago_unit(post)
    }
  end

  test "no user id params list unfavorited chosen resource", %{conn: conn} do
    user =  Repo.insert! User.changeset(%User{}, %{nickname: "121", avatar_url: "http://www.a/b.jpg", openid: "12213"})
    changeset = Post.changeset(%Post{}, @valid_attrs) 
                |> Ecto.Changeset.put_change(:user_id, user.id)
    post = Repo.insert! changeset
    
    conn = get conn, post_path(conn, :index)
    
    assert hd(json_response(conn, 200)["data"]) == %{"id" => post.id,
      "dream" => post.dream,
      "reality" => post.reality,
      "progress" => post.progress,
      "count" => post.count,
      "user_id" => user.id,
      "gender" => user.gender, 
      "nickname" => user.nickname,
      "avatar_url" => user.avatar_url,
      "favorited" => false,
      "published_at" => Post.time_ago_unit(post)
    }
  end



  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, post_path(conn, :show, -1), user_id: 2
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Post, dream: @valid_attrs.dream)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, post_path(conn, :create), post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    post = Repo.insert! %Post{}
    conn = put conn, post_path(conn, :update, post), post: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Post, dream: @valid_attrs.dream)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    post = Repo.insert! %Post{}
    conn = put conn, post_path(conn, :update, post), post: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    post = Repo.insert! %Post{}
    conn = delete conn, post_path(conn, :delete, post)
    assert response(conn, 204)
    refute Repo.get(Post, post.id)
  end

  test "my posts list", %{conn: conn} do
    user = insert(:user)
    user2 = insert(:user)
    insert_list(10, :post, user: user2)
    insert_list(10, :post, user: user)
    conn = get conn, post_path(conn, :my, %{user_id: user.id })
    posts = json_response(conn, 200)["data"]
    assert length(posts) == 2 
  end 
end
