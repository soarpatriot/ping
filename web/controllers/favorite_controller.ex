defmodule Ping.FavoriteController do
  use Ping.Web, :controller

  alias Ping.Favorite

  def index(conn, _params) do
    favorites = Repo.all(Favorite)
    render(conn, "index.json", favorites: favorites)
  end

  def create(conn, %{"favorite" => favorite_params}) do
    changeset = Favorite.changeset(%Favorite{}, favorite_params)

    case Repo.insert(changeset) do
      {:ok, favorite} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", favorite_path(conn, :show, favorite))
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

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(favorite)

    send_resp(conn, :no_content, "")
  end
end
