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
      user: build(:user),
    }
  end

end
