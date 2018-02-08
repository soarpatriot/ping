defmodule Ping.WechatController do
  use Ping.Web, :controller

  def openid(conn, %{"js_code" => js_code}) do
   
    we_config = Application.get_env(:wechat, Wechat)
    url = "#{we_config[:url]}?appid=#{we_config[:appid]}&secret=#{we_config[:secret]}&js_code=#{js_code}&grant_type=authorization_code"
    # IO.puts url
		case HTTPoison.get(url) do
			{:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        de_body =  Poison.decode!(body)
        case de_body["errcode"] do 
          nil ->
            IO.inspect de_body
            render(conn, "show.json", %{res: de_body})
          _ -> 
            conn |> put_status(:not_acceptable)
                 |> render( "error.json", %{code: de_body["errcode"], message: de_body["errmsg"]})
        end
			{:ok, %HTTPoison.Response{status_code: 404}} ->
				IO.puts "Not found :("
        render(conn, "not_found.json", %{code: 404, message: "not found"})
			{:error, %HTTPoison.Error{reason: reason}} ->
        render(conn, "error.json", %{code: 500, message: "server error"})
		end
  end

end

