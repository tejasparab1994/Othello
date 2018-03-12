defmodule Othello.Player do
  @enforce_keys [:name]
  # player1 or player2 thing.

  defstruct [:name]

  @doc """
  Creates a player with the given `name` and `color`.
  """
  def new(name) do
    %Othello.Player{name: name}
  end
end
