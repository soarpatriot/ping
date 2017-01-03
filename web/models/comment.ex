defmodule Ping.Comment do
  use Ping.Web, :model
  use Timex.Ecto.Timestamps
  use Timex
 
  schema "comments" do
    field :content, :string
    field :published_at, :string, virtual: true    
    belongs_to :user, Ping.User
    belongs_to :post, Ping.Post
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:content, :user_id, :post_id])
    |> validate_required([:content, :user_id, :post_id])
  end
end
