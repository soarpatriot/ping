defmodule Ping.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: Ping.Repo

  # without Ecto
  # use ExMachina

  def user_factory do
    %Ping.User{
      nickname: "Jane Smith",
    }
  end

  def post_factory do
    %Ping.Post{
      dream: "dream",
      reality: "reality",
      progress: 80,
      count: 0,
      user: build(:user),
    }
  end
  def favorite_factory do
    %Ping.Favorite{
      post: build(:post),
      user: build(:user)
    }
  end

  def image_factory do
    %Ping.Image{
      post: build(:post),
      key: "324",
      hash: "hash",
      url: "url"
    }
  end



end
