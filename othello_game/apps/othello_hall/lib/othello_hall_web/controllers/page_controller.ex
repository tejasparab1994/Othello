defmodule OthelloHallWeb.PageController do
  use OthelloHallWeb, :controller

  def index(conn, _params) do
    render(conn, "lobby.html")
  end

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"player" => %{"name" => name}}) do
    player = Othello.Player.new(name)

    conn
    |> put_session(:current_player, player)
    |> redirect(to: page_path(conn, :index))
  end

  def delete(conn, _) do
    conn
    |> delete_session(:current_player)
    |> put_flash(:info, "Switch Player")
    |> redirect(to: "/")
  end

  def lobby(conn, _params) do
    render(conn, "lobby.html", current_player: get_session(conn, :current_player))
  end

  def redirect(conn) do
    path = get_session(conn, :return_to) || game_path(conn, :new)

    conn
    |> put_session(:return_to, nil)
    |> redirect(to: path)
  end
end
