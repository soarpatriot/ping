defmodule Ping.PostView do
  use Ping.Web, :view
  #import Kerosene.JSON

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
      progress: post.progress,
      published_at: post.published_at
    }
  end

  def render("post-user.json", %{post: post}) do 
    %{id: post.id,
      dream: post.dream,
      reality: post.reality,
      progress: post.progress,
      count: post.count,
      user_id: post.user.id,
      gender: post.user.gender,
      avatar_url: post.user.avatar_url,
      nickname: post.user.nickname,  
      favorited: post.favorited,
      published_at: post.published_at,
      images: render_many(post.images, Ping.ImageView, "index.json")
    }
    
  end
  def render("show-commented.json", %{post: post}) do 
    %{id: post.id,
      dream: post.dream,
      reality: post.reality,
      progress: post.progress,
      count: post.count,
      user_id: post.user.id,
      gender: post.user.gender,
      avatar_url: post.user.avatar_url,
      nickname: post.user.nickname,  
      favorited: post.favorited,
      published_at: post.published_at,
      comments: render_many(post.comments, Ping.CommentView, "user-comment.json")
    }
    
  end

  #def render("comments.json", %{comments: comments}) do 
  #  %{render_many(posts, Ping.PostView, "comment.json")}
  #end

  def render("posts-user.json", %{posts: posts, pagination: pagination}) do
    %{data: render_many(posts, Ping.PostView, "post-user.json"),
      pagination: pagination
      }
  end
  def render("my-posts.json", %{posts: posts}) do
    %{data: render_many(posts, Ping.PostView, "post-user.json")}
  end

end
