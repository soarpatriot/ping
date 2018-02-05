defmodule Ping.Favorite do
  use Ping.Web, :model
  alias Ping.Repo

  schema "favorites" do
    # field :user_id, :integer
    # field :post_id, :integer

    belongs_to :user, Ping.User
    belongs_to :post, Ping.Post
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :post_id ])
    |> validate_required([:user_id, :post_id])
  end

  def exist_fav(post, user_id) do 
  # fav_query = from f in Favorite, where: (f.user_id == ^user_id) and (f.post_id == ^post.id)
    f = Ping.Repo.get_by(Ping.Favorite, [user_id: user_id, post_id: post.id])
    case f do 
      nil -> 
        post
      _ -> 
        %{post | favorited: true}
    end
  end
end
