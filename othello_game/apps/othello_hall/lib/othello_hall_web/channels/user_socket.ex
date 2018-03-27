defmodule OthelloHallWeb.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel("games:*", OthelloHallWeb.GameChannel)
  channel("lobby:*", OthelloHallWeb.LobbyChannel)

  ## Transports
  transport(:websocket, Phoenix.Transports.WebSocket)

  def connect(%{"playerName" => playerName}, socket) do
    {:ok, assign(socket, :current_player, playerName)}
  end

  def connect(_, _socket), do: :error

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
#  def id(socket), do: "user_socket:#{socket.assigns.current_player}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     OthelloHallWeb.Endpoint.broadcast("user_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
