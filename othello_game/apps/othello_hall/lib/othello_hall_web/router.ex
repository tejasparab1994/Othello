defmodule OthelloHallWeb.Router do
  use OthelloHallWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", OthelloHallWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", PageController, :new)

    resources("/games", GameController, only: [:new, :create, :show])

    resources("/login", PageController, only: [:new, :create, :delete], singleton: true)
  end

  # Other scopes may use custom stacks.
  # scope "/api", OthelloHallWeb do
  #   pipe_through :api
  # end
end
