defmodule Ping.Router do
  use Ping.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  #scope "/", Ping do
  #  pipe_through :browser # Use the default browser stack

  #  get "/", PageController, :index
  # end

  # Other scopes may use custom stacks.
  scope "/", Ping do
    pipe_through :api
    resources "/favorites", FavoriteController, except: [:new, :edit]
    post "/favorites/up", FavoriteController, :up
    get "/posts/migration", PostController, :m_comments
    get "/posts/my", PostController, :my
    get "/tokens/qiniu", TokenController, :qiniu
    get "/wechat/openid", WechatController, :openid
    resources "/images", ImageController, except: [:new, :edit]
    resources "/posts", PostController
    resources "/users", UserController 
    resources "/comments", CommentController 
    resources "/boards", BoardController, except: [:new, :edit]
    post "/users/me", UserController, :save_or_update
  end
end
