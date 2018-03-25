defmodule Othello.Square do
  # should be true
  defstruct color: nil, i: 0, j: 0, disabled: true

  alias __MODULE__

  @doc """
  Creates a square from the given `phrase` and `points`.
  """
  def new(color = "black") do
    %Square{color: color}
  end

  def new(color = "white") do
    %Square{color: color}
  end

  @doc """
  Creates a square from the given `phrase` and `points`.
  """
  def new() do
    %Square{}
  end

  #  @doc """
  #  Creates a square from the given map with `:phrase` and `:points` keys.
  #  """
  #  def from_buzzword(%{phrase: phrase, points: points}) do
  #    Square.new(phrase, points)
  #  end
end
