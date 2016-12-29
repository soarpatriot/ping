defmodule Ping.Comment do
  use Ping.Web, :model

  schema "comments" do
    field :content, :string

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
