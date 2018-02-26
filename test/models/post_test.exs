defmodule Ping.PostTest do
  use Ping.ModelCase

  import Ping.Factory
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

  test "update comments count" do 
    post = insert(:post, dream: "35345")
    insert(:comment, content: "123", post: post)
    # posts = Ping.Repo.all(Ping.Post) |> Ping.Repo.preload(:comments)
    assert post.comments_count === 0
    Post.migrate_comments_data()
    # Post.update_comments_count(posts)
    p = Ping.Repo.get(Post, post.id)
    assert p.comments_count === 1
  end
  test "up comments count" do 
    post = insert(:post, dream: "35345")
    insert(:comment, content: "123", post: post)
    # posts = Ping.Repo.all(Ping.Post) |> Ping.Repo.preload(:comments)
    Post.up_comments(post.id)
    # Post.update_comments_count(posts)
    p = Ping.Repo.get(Post, post.id)
    assert p.comments_count === 1
  end

end
