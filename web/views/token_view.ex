defmodule Ping.TokenView do
  use Ping.Web, :view


  def render("show.json", %{token: token}) do
    %{
      uptoken: token
    }
  end
end
