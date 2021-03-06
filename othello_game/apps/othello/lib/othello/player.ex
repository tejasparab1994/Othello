defmodule Othello.Player do
  @enforce_keys [:name]
  # player1 or player2 thing.

  defstruct [:name, :color, score: 0]

  @doc """
  Creates a player with the given `name` and `color`.
  """

  def new(name) do
    %Othello.Player{name: name}
  end

  def new(name, color = "black") do
    %Othello.Player{name: name, color: color}
  end

  @doc """
  Creates a player with the given `name` and `color`.
  """
  def new(name, color = "white") do
    %Othello.Player{name: name, color: color}
  end
end
