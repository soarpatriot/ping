defmodule Ping.Favorite do
  use Ping.Web, :model

  schema "favorites" do
    field :user_id, :integer
    field :post_id, :integer

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :post_id])
    |> validate_required([:user_id, :post_id])
  end

  def exist(_user_id, _post_id) do 
  #case Repo.find(Post,%{user_id: user_id, post_id: post_id}) do 
  #    nil -> %Favorite{user_id: user_id, post_id: post_id}
  #    favorite -> favorite
  #  end
  end
end
