defmodule Ping.TokenController do
  use Ping.Web, :controller

  def qiniu(conn, _params) do
    uptoken = Application.get_env(:qiniu, Qiniu)[:bucket]
      |> Qiniu.PutPolicy.build
      |> Qiniu.Auth.generate_uptoken
    
    render(conn, "show.json", %{token: uptoken})
  end

end

