defmodule Ping.Image do
  use Ping.Web, :model

  schema "images" do
    field :key, :string
    field :hash, :string
    field :url, :string
    belongs_to :post, Ping.Post

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:key, :hash, :url])
    |> validate_required([:key, :hash, :url])
  end
end
