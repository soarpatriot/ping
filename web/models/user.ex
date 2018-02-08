defmodule Ping.User do
  use Ping.Web, :model

  schema "users" do
    field :openid, :string
    field :nickname, :string
    field :gender, :integer
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

  def unpad(data) do
    to_remove = :binary.last(data)
    :binary.part(data, 0, byte_size(data) - to_remove)
  end

  def decrypt(data, key, iv) do
    IO.puts "WOrking to decrypt #{data} using #{key}"
    padded = :crypto.block_decrypt(:aes_cbc128, :base64.decode(key), :base64.decode(iv), :base64.decode(data))
    unpad(padded)
  end
end
