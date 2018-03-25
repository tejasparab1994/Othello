defmodule OthelloHallWeb.GameChannel do
  use OthelloHallWeb, :channel

  alias OthelloWeb.ChannelMonitor
  alias Othello.GameSupervisor, as: GameSupervisor
  alias OthelloHallWeb.LobbyChannel
  alias Othello.GameServer
  alias Othello.Game
  require Logger

  def join("games:" <> game_name, _params, socket) do
    current_player = current_player(socket)
    case GameServer.game_pid(game_name) do
      pid when is_pid(pid) ->
        {:ok, assign(socket, :game_name, game_name)}

      nil ->
        {:error, %{reason: "Game does not exist"}}
    end
  end

  def handle_in("games:register_for_game", _payload, socket) do
    game_name = socket.assigns.game_name
    current_player = socket.assigns.current_player

    summary = GameServer.assign_player(game_name, current_player)
    game_names = GameSupervisor.game_names()

    LobbyChannel.broadcast_current_games()
    OthelloHallWeb.Endpoint.broadcast!("games:#{game_name}", "update_game", %{gameData: summary})

    {:reply, {:ok, %{gameData: summary}}, socket}
  end

  def handle_in("games:mark_square", %{"i" => i, "j" => j}, socket) do
    game_name = socket.assigns.game_name
    current_player = socket.assigns.current_player
    summary = GameServer.mark_square(game_name, current_player, i, j)
    LobbyChannel.broadcast_current_games()
    OthelloHallWeb.Endpoint.broadcast!("games:#{game_name}", "update_game", %{gameData: summary})
    {:reply, {:ok, %{gameData: summary}}, socket}
  end


  def terminate(reason, socket) do
    game_name = socket.assigns.game_name
    game_summary = GameServer.summary(game_name)
    player_name = socket.assigns.current_player

    case game_summary do
      %{:player2 => nil} ->
        GameSupervisor.stop_game(game_name)
      _ ->
        player_name_1 = game_summary.player1.name
        player_name_2 = game_summary.player2.name
        case player_name do
          ^player_name_1 ->
            IO.puts "Player 1 has left the game"
            summary = GameServer.declare_winner(game_name, :player2)
            GameSupervisor.stop_game(game_name)
            OthelloHallWeb.Endpoint.broadcast!("games:#{game_name}", "update_game", %{gameData: summary})
          ^player_name_2 ->
            IO.puts "Player 2 has left the game"
            summary = GameServer.declare_winner(game_name, :player1)
            GameSupervisor.stop_game(game_name)
            OthelloHallWeb.Endpoint.broadcast!("games:#{game_name}", "update_game", %{gameData: summary})
          _ -> :ok
        end
    end
    LobbyChannel.broadcast_current_games()
    :ok
  end

  def handle_in("new_chat_message", %{"body" => body, "name" => name}, socket) do
    broadcast!(
      socket,
      "new_chat_message",
      %{
        name: current_player(socket).name,
        body: body
      }
    )

    {:reply, {:ok, %{body: body, name: name}}, socket}
  end

  defp current_player(socket) do
    socket.assigns.current_player
  end
end
