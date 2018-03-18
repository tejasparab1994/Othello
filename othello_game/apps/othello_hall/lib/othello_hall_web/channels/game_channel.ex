defmodule OthelloHallWeb.GameChannel do
  use OthelloHallWeb, :channel

  alias OthelloHallWeb.ChannelMonitor
  alias Othello.GameSupervisor, as: GameSupervisor
  alias OthelloWeb.LobbyChannel
  alias Othello.GameServer
  alias OthelloHallWeb.Presence
  require Logger

  def join("games:" <> game_name, _params, socket) do
    # Logger.debug("Joining Game Channel #{{game_name}}", game_name: game_name)

    current_player = current_player(socket)
    IO.inspect(socket.assigns)

    # users =
    #   ChannelMonitor.user_joined("games:" <> game_name, current_player)["games:" <> game_name]

    case GameServer.game_pid(game_name) do
      pid when is_pid(pid) ->
        send(self(), {:after_join, game_name, current_player})
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

    # should be current_player(socket).name
    {:ok, _} =
      Presence.track(socket, current_player(socket), %{
        online_at: inspect(System.system_time(:seconds)),
        # should be current_player(socket).color
        color: current_player(socket)
      })

    {:noreply, socket}
  end

  def terminate(reason, socket) do
    Logger.debug("Terminating GameChannel #{socket.assigns.game_name} #{inspect(reason)}")
    IO.inspect("in here? right now?")
    current_player = current_player(socket)
    game_name = socket.assigns.game_name

    case Game.player_left(game_name, current_player) do
      {:ok, game} ->
        GameSupervisor.stop_game(game_name)

        broadcast(socket, "game:over", %{game: game})
        broadcast(socket, "game:player_left", %{current_player: current_player})

        :ok

      _ ->
        :ok
    end
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
