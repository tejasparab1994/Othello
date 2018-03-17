defmodule OthelloWeb.GameChannel do
  use OthelloWeb, :channel

  alias OthelloWeb.ChannelMonitor
  alias Othello.GameSupervisor
  alias OthelloWeb.LobbyChannel
  alias Othello.GameServer

  def join("games:" <> game_name, _params, socket) do
    current_user = socket.assigns.current_user
    users = ChannelMonitor.user_joined("games:" <> game_name, current_user)["games:" <> game_name]

    case GameServer.game_pid(game_name) do
      pid when is_pid(pid) ->
        send(self(), {:after_join, game_name})
        {:ok, socket}

      nil ->
        {:error, %{reason: "Game does not exist"}}
    end
  end

  def handle_info({:after_join, connected_users}, socket) do
    broadcast!(socket, "user:joined", %{users: connected_users})

    {:noreply, socket}
  end
end
