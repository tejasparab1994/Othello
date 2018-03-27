defmodule OthelloHallWeb.Router do
  use OthelloHallWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :get_current_user
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  def get_current_user(conn, _params) do
    current_player = get_session(conn, :current_player)
    assign(conn, :current_player, current_player)
  end

  scope "/", OthelloHallWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :index)
    get("/lobby", PageController, :lobby)

    resources("/games", GameController, only: [:new, :create, :show])

    resources("/login", PageController, only: [:new, :create, :delete], singleton: true)
  end

  # Other scopes may use custom stacks.
  # scope "/api", OthelloHallWeb do
  #   pipe_through :api
  # end
end
