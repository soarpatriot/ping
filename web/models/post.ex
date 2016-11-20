defmodule Ping.Post do
  use Ping.Web, :model

  schema "posts" do
    field :dream, :string
    field :reality, :string
    field :progress, :integer
    
    belongs_to :user, Ping.User
    timestamps()
  end

  @optional_fields ~w(user_id)

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:dream, :reality, :progress])
    |> validate_required([:dream, :reality, :progress])
  end
end
