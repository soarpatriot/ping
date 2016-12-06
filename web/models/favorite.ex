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
end
