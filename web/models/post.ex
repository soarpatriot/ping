defmodule Ping.Post do
  use Ping.Web, :model

  schema "posts" do
    field :dream, :string
    field :reality, :string
    field :progress, :integer
    field :count, :integer
     
    field :favorited, :boolean, virtual: true

    has_many   :favorites, Ping.Favorite 
    belongs_to :user, Ping.User
    timestamps()
  end

  @optional_fields ~w(user_id)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:dream, :reality, :progress, :user_id, :count])
    |> validate_required([:dream, :reality, :progress, :user_id])
  end

  def up(post) do 
    post 
    |> Ecto.Changeset.change(%{count:  post.count + 1 } )
  end

  def down(post) do 
    post 
    |> Ecto.Changeset.change(%{count:  post.count - 1 } )
  end

  def user_fav([ head | tail ] ) do 
    case head.favorites do 
      [] -> 
      #h = head |> Ecto.Changeset.change(%{favorited:  true } )
        # h = head
        # h.favorited = true
        #h = head |> Ecto.Changeset.change(%{favorited:  true } )
        h = Map.merge(head, %{favorited:  false } )
        [ h |  user_fav(tail) ]
      _ -> 
      #h = head
      #  h.favorited = false
      #h =head |> Ecto.Changeset.change(%{favorited:  false } )
        h = Map.merge(head, %{favorited:  true } )
        [ h |  user_fav(tail) ]
    end
  end

  def user_fav([]) do 
    []
  end
end
