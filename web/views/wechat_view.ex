defmodule Ping.WechatView do
  use Ping.Web, :view


  def render("show.json", %{res: res}) do
    %{
      openid: res["openid"],
      session_key: res["session_key"],
    }
  end
  def render("not_found.json", %{code: code, message: message}) do
    %{
      code: code,
      message: message
    }
  end
  def render("error.json", %{code: code, message: message}) do
    %{
      code: code,
      message: message
    }
  end


end
