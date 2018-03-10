defmodule OthelloHallWeb.PageController do
  use OthelloHallWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
