defmodule OthelloHallWeb.GameController do
  use OthelloHallWeb, :controller

  plug(:require_player)

  alias Othello.{GameServer, GameSupervisor}
  alias OthelloHallWeb.LobbyChannel

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, _) do
    game_name = OthelloHall.HaikuName.generate()
    current_player = get_session(conn, :current_player)
    current_player = %{current_player | color: "black"}

    case GameSupervisor.start_game(game_name) do
      {:ok, _game_pid} ->
        LobbyChannel.broadcast_current_games()
        redirect(conn, to: game_path(conn, :show, game_name))

      {:error, _error} ->
        conn
        |> put_flash(:error, "Unable to start game!")
        |> redirect(to: page_path(conn, :lobby))
    end
  end

  def show(conn, %{"id" => game_name}) do
    case GameServer.game_pid(game_name) do
      pid when is_pid(pid) ->
        conn
        |> assign(:game_name, game_name)
        |> render("show.html", current_player: get_session(conn, :current_player))

      nil ->
        conn
        |> put_flash(:error, "Game not found!")
        |> redirect(to: page_path(conn, :lobby))
    end
  end

  defp require_player(conn, _opts) do
    if get_session(conn, :current_player) do
      conn
    else
      conn
      |> put_session(:return_to, conn.request_path)
      |> redirect(to: page_path(conn, :new))
      |> halt()
    end
  end

  defp generate_auth_token(conn) do
    current_player = get_session(conn, :current_player)
    Phoenix.Token.sign(conn, "player auth", current_player)
  end
end
