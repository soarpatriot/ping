defmodule Ping.Post do
  use Ping.Web, :model
  use Timex.Ecto.Timestamps
  # use Kerosene, per_page: 2
  use Timex
  use Gettext, otp_app: :ping
  require IEx
  alias Ping.Repo

  schema "posts" do
    field :dream, :string
    field :reality, :string
    field :progress, :integer
    field :count, :integer
    field :comments_count, :integer, default: 0
    
    field :published_at, :string, virtual: true    
    field :favorited, :boolean, virtual: true, default: false

    has_many   :favorites, Ping.Favorite, on_delete: :delete_all
    has_many   :comments, Ping.Comment, on_delete: :delete_all
    has_many   :images, Ping.Image, on_delete: :delete_all
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
    |> validate_required([:dream, :user_id])
  end

  def up(post) do 
    case post do 
      nil -> 
        IO.puts "post is nil!"
      _ -> 
        post 
        |> Ecto.Changeset.change(%{count:  post.count + 1 } )
        |> Repo.update
    end
  end

  def down(post) do 
    case post do 
      nil -> 
        IO.puts "post is nil!"
      _ -> 
        post 
        |> Ecto.Changeset.change(%{count:  post.count - 1 } )
        |> Repo.update
   
    end
  end

  def up_comments(post_id) do 
    post = Repo.get(Ping.Post, post_id) 
    post
      |> Ecto.Changeset.change(%{comments_count:  post.comments_count + 1 } )
      |> Repo.update
 
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
  
  def with_comments(query) do 
    from q in query, preload: [comments: :user]
  end
  def with_user(query) do 
    from q in query, preload: [:user]
  end
  def with_images(query) do 
    from q in query, preload: [:images]
  end
 
  def update_comments_count([]) do
    []
  end
  def update_comments_count([head | tail]) do
    comments_count = length(head.comments) 
    h = Ecto.Changeset.change(head, %{comments_count: comments_count})
      |> Ping.Repo.update

    [h | update_comments_count(tail) ]
  end

  def migrate_comments_data() do 
    posts = Ping.Repo.all(Ping.Post) |> Ping.Repo.preload(:comments)
            |> Ping.Post.update_comments_count
  end
end
