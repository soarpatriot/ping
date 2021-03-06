defmodule Ping.FavoriteView do
  use Ping.Web, :view

  def render("index.json", %{favorites: favorites}) do
    %{data: render_many(favorites, Ping.FavoriteView, "favorite.json")}
  end

  def render("show.json", %{favorite: favorite}) do
    %{data: render_one(favorite, Ping.FavoriteView, "favorite.json")}
  end

  def render("up.json", %{post: post}) do
    #%{data: render_one(post, Ping.FavoriteView, "po.json")}
    %{
      data: %{
      post_id: post.id,
      count: post.count }
    }
 
  end

  def render("po.json", %{post: post}) do
    %{id: post.id,
      count: post.count }
  end
  def render("favorite-post.json", %{favorite: favorite}) do
    %{id: favorite.id,
      user_id: favorite.user_id,
      post_id: favorite.post_id,
      post: render_one(favorite.post, Ping.PostView, "post.json")
    }
 
  end


  def render("favorite.json", %{favorite: favorite}) do
    %{id: favorite.id,
      user_id: favorite.user_id,
      post_id: favorite.post_id}
  end
end
