defmodule Ping.FavoriteController do
  use Ping.Web, :controller

  alias Ping.Favorite
  alias Ping.Post
  require IEx

  def index(conn, _params) do
    favorites = Repo.all(Favorite)
    render(conn, "index.json", favorites: favorites)
  end
  def up(conn, %{"favorite" => favorite_params}) do
    changeset = Favorite.changeset(%Favorite{}, favorite_params)
    #Favorite.exist()    
    #changeset = Favorite.changeset(favorite, favorite_params)
    case changeset.valid? do 
      true ->
        favorite = Repo.get_by(Favorite, 
                           %{user_id: favorite_params["user_id"],
                           post_id: favorite_params["post_id"]})
        result = 
          case favorite do 
            nil ->  
              %Favorite{} 
              |>  Favorite.changeset(favorite_params)
              |>  Repo.insert
              
              Repo.get(Post,favorite_params["post_id"]) 
                |> Post.up  
                |> Repo.update
            favorite -> 
              favorite 
              |> Repo.delete  

              Repo.get(Post,favorite_params["post_id"]) 
                |> Post.down  
                |> Repo.update
 
          end
     
        #changeset = Favorite.changeset(favorite, favorite_params)
        case result do
          {:ok, post} ->
            conn
            |> put_status(:created)
            # |> put_resp_header("location", favorite_path(conn, :show, post))
            |> render("up.json", post: post)
          {:error, changeset} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render(Ping.ChangesetView, "error.json", changeset: changeset)
        end
      false -> 
        conn
         |> put_status(:unprocessable_entity)
         |> render(Ping.ChangesetView, "error.json", changeset: changeset) 
      
    end

  end


  def create(conn, %{"favorite" => favorite_params}) do
    changeset = Favorite.changeset(%Favorite{}, favorite_params)
    #Favorite.exist()    
    #changeset = Favorite.changeset(favorite, favorite_params)
    #
    case Repo.insert(changeset) do
      {:ok, favorite} ->
        Repo.get(Post,favorite.post_id) 
          |> Post.up  
 
        conn
        |> put_status(:created)
        |> put_resp_header("location", comment_path(conn, :show, favorite))
        |> render("show.json", favorite: favorite)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Ping.ChangesetView, "error.json", changeset: changeset)
    end


  end

  def show(conn, %{"id" => id}) do
    favorite = Repo.get!(Favorite, id)
    render(conn, "show.json", favorite: favorite)
  end

  def update(conn, %{"id" => id, "favorite" => favorite_params}) do
    favorite = Repo.get!(Favorite, id)
    changeset = Favorite.changeset(favorite, favorite_params)

    case Repo.update(changeset) do
      {:ok, favorite} ->
        render(conn, "show.json", favorite: favorite)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Ping.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    favorite = Repo.get!(Favorite, id)
    case favorite.post_id do 
      nil -> nil
      _ -> 
        post = Repo.get(Post,favorite.post_id) 
        post = Repo.get(Post,favorite.post_id) 
        post  |> Post.down 
    end
 
    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(favorite)

    send_resp(conn, :no_content, "")
  end
end
