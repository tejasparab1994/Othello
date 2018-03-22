defmodule OthelloHallWeb.GameChannel do
  use OthelloHallWeb, :channel

  alias OthelloWeb.ChannelMonitor
  alias Othello.GameSupervisor, as: GameSupervisor
  alias OthelloHallWeb.LobbyChannel
  alias Othello.GameServer
  require Logger

  def join("games:" <> game_name, _params, socket) do
#    Logger.debug("Joining Game Channel #{{game_name}}", game_name: game_name)

    current_player = current_player(socket)
    IO.inspect(current_player)

#    users =
#      ChannelMonitor.user_joined("games:" <> game_name, current_player)["games:" <> game_name]

    case GameServer.game_pid(game_name) do
      pid when is_pid(pid) ->
#        send(self(), {:after_join, game_name, current_player})
        {:ok, assign(socket, :game_name, game_name)}

      nil ->
        {:error, %{reason: "Game does not exist"}}
    end
  end

  def handle_info({:after_join, game_name, current_player}, socket) do
    summary = GameServer.summary(game_name)

    push(socket, "game_summary", summary)
    push(socket, "presence_state", Presence.list(socket))
    broadcast!(socket, "user:joined", %{users: current_player})

    {:ok, _} =
      Presence.track(socket, current_player(socket).name, %{
        online_at: inspect(System.system_time(:seconds)),
        color: current_player(socket).color
      })

    {:noreply, socket}
  end

  def broadcast_current_game(gameName, game) do

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
    Logger.debug("Terminating GameChannel #{socket.assigns.game_name} #{inspect(reason)}")

    current_player = current_player(socket)
    game_name = socket.assigns.game_name

    GameSupervisor.stop_game(game_name)
    LobbyChannel.broadcast_current_games()
    :ok
  end

  def handle_in("new_chat_message", %{"body" => body}, socket) do
    broadcast!(socket, "new_chat_message", %{
      name: current_player(socket).name,
      body: body
    })

    {:noreply, socket}
  end

  defp current_player(socket) do
    socket.assigns.current_player
  end
end
