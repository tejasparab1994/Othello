defmodule OthelloWeb.GameChannel do
  use OthelloWeb, :channel

  alias OthelloWeb.ChannelMonitor
  alias Othello.GameSupervisor, as: GameSupervisor
  alias OthelloWeb.LobbyChannel
  alias Othello.GameServer
  require Logger

  def join("games:" <> game_name, _params, socket) do
    Logger.debug("Joining Game Channel #{{game_name}}", game_name: game_name)
    IO.inspect(current_user)
    current_user = socket.assigns.current_user
    users = ChannelMonitor.user_joined("games:" <> game_name, current_user)["games:" <> game_name]

    case GameServer.game_pid(game_name) do
      pid when is_pid(pid) ->
        send(self(), {:after_join, game_name, current_user})
        {:ok, assign(socket, :game_name, game_name)}

      nil ->
        {:error, %{reason: "Game does not exist"}}
    end
  end

  def handle_info({:after_join, game_name, current_user}, socket) do
    summary = GameServer.summary(game_name)

    push(socket, "game_summary", summary)

    broadcast!(socket, "user:joined", %{users: connected_users})

    {:noreply, socket}
  end
end
