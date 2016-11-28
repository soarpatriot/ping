defmodule Ping.PostController do
  use Ping.Web, :controller

  alias Ping.Post

  def index(conn,  params) do
    p = Map.get(params, "page", 1)
    pg = p - 1
    ps = Map.get(params, "page_size", 10)
    query = Post
           |> limit(^ps) 
           |> offset(^pg) 
    posts = Repo.all(query)
            |> Repo.preload(:user) 
    render(conn, "posts-user.json", posts: posts)
 
  end


  def create(conn, post_params) do
    changeset = Post.changeset(%Post{}, post_params)

    case Repo.insert(changeset) do
      {:ok, post} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", post_path(conn, :show, post))
        |> render("show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Ping.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    post = Repo.get!(Post, id) 
            |> Repo.preload(:user) 
    render(conn, "show-user.json", post: post)
  end

  def update(conn, %{"id" => id, "post" => post_params}) do
    post = Repo.get!(Post, id)
    changeset = Post.changeset(post, post_params)

    case Repo.update(changeset) do
      {:ok, post} ->
        render(conn, "show.json", post: post)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Ping.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Repo.get!(Post, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(post)

    send_resp(conn, :no_content, "")
  end
end
