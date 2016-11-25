defmodule Ping.UserView do
  use Ping.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, Ping.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, Ping.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      openid: user.openid,
      nickname: user.nickname,
      gender: user.gender,
      province: user.province,
      country: user.country,
      city: user.city,
      avatar_url: user.avatar_url}
  end
end
