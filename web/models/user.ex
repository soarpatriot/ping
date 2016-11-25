defmodule Ping.User do
  use Ping.Web, :model

  schema "users" do
    field :openid, :string
    field :nickname, :string
    field :gender, :string
    field :province, :string
    field :country, :string
    field :city, :string
    field :avatar_url, :string
    
    has_many :posts, Ping.Post
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:openid, :nickname, :gender, :province, :country, :avatar_url,:city])
    |> validate_required([:openid, :nickname, :avatar_url])
  end
end
