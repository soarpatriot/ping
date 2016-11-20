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
      sex: user.sex,
      province: user.province,
      country: user.country,
      headimgurl: user.headimgurl}
  end
end
