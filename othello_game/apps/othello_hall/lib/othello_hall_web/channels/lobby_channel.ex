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
    IO.puts("Request for current games")

    game_names = GameSupervisor.game_names()
    # IO.inspect("current game")
    # IO.inspect(game_names)
    {:reply, {:ok, %{current_games: game_names}}, socket}
  end

  def broadcast_current_games do
    IO.puts("Request for broadcasting current games")
    game_names = GameSupervisor.game_names()
    # IO.inspect("bbroadcast_current_games")
    # IO.inspect(game_names)
    OthelloHallWeb.Endpoint.broadcast!("lobby:join", "update_games", %{current_games: game_names})
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("lobby:new_game", payload, socket) do
    {:reply, {:ok, %{current_games: %{}}}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (lobby:lobby).
  def handle_in("shout", payload, socket) do
    broadcast(socket, "shout", payload)
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
