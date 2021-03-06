defmodule Ping.PostController do
  use Ping.Web, :controller

  alias Ping.Post
  alias Ping.Image
  alias Ping.Favorite
  require IEx
  def index(conn,  params) do
    user_id = Map.get(params, "user_id", 0)
    fav_query = from f in Favorite, where: f.user_id == ^user_id 
    page = Post 
            |> order_by([p], desc: p.id)
            |> Repo.paginate(params)
    posts = page.entries
    pagination = %{
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    }
    ass_posts = posts  
      |> Repo.preload(:user) 
      |> Repo.preload(:images) 
      |> Post.time_ago
    result = 
      case user_id > 0 do 
        true -> 
          ass_posts
            |> Repo.preload(favorites: fav_query)
            |> Post.user_fav
        false ->
          ass_posts 
      end
    # p_result = %{posts: result, pagination: pagination}
    render(conn, "posts-user.json", posts: result, pagination: pagination)
 
  end

  def my(conn,  params) do
    user_id = params["user_id"]

    # pagination = %{page: p, page_size: ps} 
    query = from p in Post, where: p.user_id == ^user_id, order_by: [desc: p.id]
    fav_query = from f in Favorite, where: f.user_id == ^user_id
    page = query
            |> Repo.paginate(params)
    posts = page.entries
    pagination = %{
      page_number: page.page_number,
      page_size: page.page_size,
      total_pages: page.total_pages,
      total_entries: page.total_entries
    }
    
    ass_posts = posts  
      |> Repo.preload(:user) 
      |> Repo.preload(:images) 
      |> Post.time_ago
    result = 
      case user_id > 0 do 
        true -> 
          ass_posts
            |> Repo.preload(favorites: fav_query)
            |> Post.user_fav
        false ->
          ass_posts 
      end
    # p_result = %{posts: result, pagination: pagination}
    render(conn, "posts-user.json", posts: result, pagination: pagination)

  end


  def create(conn, post_params) do

    # if images exist, save images
    im_params = post_params["images"] 
    images =  
      case is_nil(im_params) do 
        false -> 
          Enum.map(im_params, fn(im) -> 
                Image.changeset(%Image{}, im)
                   end)
        true ->  
          []
    end
    post = Post.changeset(%Post{}, post_params)
    changeset = Ecto.Changeset.put_assoc(post, :images, images)
    # changeset = Post.changeset(%Post{}, post_params)

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

  def show(conn, %{"id" => id, "user_id" => user_id}) do
    post  = Post 
              |> Post.with_user
              |> Post.with_comments
              |> Post.with_images
              |> Repo.get!(id)
              |> Post.time_in
              |> Favorite.exist_fav(user_id)
    comments = Post.time_ago(post.comments)

    t_post = Map.merge(post, %{comments:  comments } )
    #|> Repo.preload(comments: [:user])
    #        |> Repo.preload(:user)

    render(conn, "show-commented.json", post: t_post)
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
