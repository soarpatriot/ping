defmodule Ping.Post do
  use Ping.Web, :model
  use Timex.Ecto.Timestamps
  use Timex
  use Gettext, otp_app: :ping
  require IEx
  schema "posts" do
    field :dream, :string
    field :reality, :string
    field :progress, :integer
    field :count, :integer
    
    field :published_at, :string, virtual: true    
    field :favorited, :boolean, virtual: true, default: false

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
      nil -> 
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

  def time_ago([head|tail]) do 
  #i_at = Timex.shift(head.inserted_at, minutes: -1) |> Timex.format("{relative}", :relative)
    h = time_in(head)
    [h | time_ago(tail) ]
  end
  def time_ago([]) do 
    []
  end
  
  def time_in(head) do 
    i_at = time_ago_unit(head)
    Map.merge(head, %{published_at: i_at} )
  end
  def time_ago_unit(head) do 
    Timex.from_now(head.inserted_at, "zh_CN") 
    #Gettext.dgettext Ping.Gettext, "relative_time", i_at
    #Gettext.dgettext "zh", "relative_time", i_at, %{}
    #Timex.Translator.translate("zh","relative_time", i_at)
    #    {:ok, str} ->
      #      str
    #  {:error, str} ->
      #      "久远"
    #   {_, str} ->
      #      str
      # end
    #i_at = Timex.shift(head.inserted_at, minutes: -1) |> Timex.format("{relative}", :relative)
  end
end
