defmodule Ping.UserController do
  use Ping.Web, :controller

  alias Ping.User

  #def index(conn, _params) do
  #  users = Repo.all(User)
  #   render(conn, "index.json", users: users)
  # end

  def create(conn, user_params) do
    changeset = User.changeset(%User{}, user_params)
     
    
    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", user_path(conn, :show, user))
        |> render("show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Ping.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.json", user: user)
  end

  def update(conn, %{"id" => id, "user" => user_params}) do
    user = Repo.get!(User, id)
    changeset = User.changeset(user, user_params)

    case Repo.update(changeset) do
      {:ok, user} ->
        render(conn, "show.json", user: user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Ping.ChangesetView, "error.json", changeset: changeset)
    end
  end
  def save_or_update(conn, user_params) do 
    user = Repo.get_by(User, openid: user_params["openid"])
    result = 
      case user do 
        nil ->  %User{} 
        user -> user 
      end
      |> User.changeset(user_params)
      |> Repo.insert_or_update
    case result do
        {:ok, result}       -> # Inserted or updated with success
          render(conn, "show.json", user: result)
        {:error, user_params} -> # Something went wrong
          conn
          |> put_status(:unprocessable_entity)
          |> render(Ping.ChangesetView, "error.json", changeset: user_params)
 
    end 
  end
  def delete(conn, %{"id" => id}) do
    user = Repo.get!(User, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(user)

    send_resp(conn, :no_content, "")
  end
end
