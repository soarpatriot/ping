defmodule Ping.PostView do
  use Ping.Web, :view

  def render("index.json", %{posts: posts}) do
    %{data: render_many(posts, Ping.PostView, "post.json")}
  end

  def render("show.json", %{post: post}) do
    %{data: render_one(post, Ping.PostView, "post.json")}
  end
  def render("show-user.json", %{post: post}) do
    %{data: render_one(post, Ping.PostView, "post-user.json")}
  end


  def render("post.json", %{post: post}) do
    %{id: post.id,
      dream: post.dream,
      reality: post.reality,
      progress: post.progress}
  end

  def render("post-user.json", %{post: post}) do 
    %{id: post.id,
      dream: post.dream,
      reality: post.reality,
      progress: post.progress,
      user_id: post.user.id,
      gender: post.user.gender,
      avatar_url: post.user.avatar_url,
      nickname: post.user.nickname   
    }
    
  end

  def render("posts-user.json", %{posts: posts}) do 
    %{data: render_many(posts, Ping.PostView, "post-user.json")}
  end
end
