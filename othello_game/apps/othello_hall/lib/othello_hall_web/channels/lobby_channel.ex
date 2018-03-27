defmodule OthelloHallWeb.LobbyChannel do
  use OthelloHallWeb, :channel

  alias Othello.GameSupervisor

  def join("lobby:join", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("lobby:current_games", payload, socket) do
    game_names = GameSupervisor.game_names()
    {:reply, {:ok, %{current_games: game_names}}, socket}
  end

  def broadcast_current_games do
    game_names = GameSupervisor.game_names()
    OthelloHallWeb.Endpoint.broadcast!("lobby:join", "update_games", %{current_games: game_names})
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("lobby:new_game", payload, socket) do
    {:reply, {:ok, %{current_games: %{}}}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
