defmodule Ping.TokenControllerTest do
  use Ping.ConnCase


  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "gen qiniu token", %{conn: conn} do
    conn = get conn, token_path(conn, :qiniu)
    assert json_response(conn, 200)["uptoken"]
  end
end
