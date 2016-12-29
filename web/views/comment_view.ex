defmodule Ping.CommentView do
  use Ping.Web, :view

  def render("index.json", %{comments: comments}) do
    %{data: render_many(comments, Ping.CommentView, "comment.json")}
  end

  def render("show.json", %{comment: comment}) do
    %{data: render_one(comment, Ping.CommentView, "comment.json")}
  end

  def render("comment.json", %{comment: comment}) do
    %{id: comment.id,
      content: comment.content,
      user_id: comment.user_id,
      post_id: comment.post_id}
  end
end
