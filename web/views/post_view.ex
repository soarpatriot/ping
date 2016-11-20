defmodule Ping.PostView do
  use Ping.Web, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, Ping.PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, Ping.PostView, "post.json")}
  end

  def render("post.json", %{post: post}) do
    %{id: post.id,
      dream: post.dream,
      reality: post.reality,
      process: post.progress}
  end
end
