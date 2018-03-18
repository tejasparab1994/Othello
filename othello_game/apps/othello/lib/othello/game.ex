defmodule Othello.Game do
  @enforce_keys [:squares]
  defstruct squares: nil,
            scores: %{},
            winner: nil,
            inProgress: false,
            player1: nil,
            player2: nil

  alias Othello.{Buzzwords, Game, Square, OthelloChecker, Player}

  # @doc """
  # Creates a game with a `size` x `size` collection of squares
  # taken randomly from the given list of `buzzwords` where
  # each buzzword is of the form `%{phrase: "Upsell", points: 10}`.
  # """
  # def new() when is_integer(size) do
  #   buzzwords = Buzzwords.read_buzzwords()
  #   Game.new(buzzwords, size)
  # end

  @doc """
  Creates a game with a `size` x `size` collection of squares
  taken randomly from the given list of `buzzwords` where
  each buzzword is of the form `%{phrase: "Upsell", points: 10}`.
  We call the read_buzzwords function and store the map in our variable.
  Post that, we take 64 buzzwords from that and assign to each square.
  So in our case for othello, how are we gonna give each square some value?
  There's something we'll have to do on mark, tic-tac-toe should help.
  """
  def new do
    squareBlack = Square.new("black")
    squareWhite = Square.new("white")
    squares = Square.new()
              |> List.duplicate(64)
              |> List.insert_at(27, squareBlack)
              |> List.insert_at(36, squareBlack)
              |> List.insert_at(28, squareWhite)
              |> List.insert_at(35, squareWhite)

    %Game{squares: squares}
  end

  def assign_player(game, playerName) do
    newgame = case game do
      %Game{ :player1 => nil } -> %{game | player1: %Player{ name: playerName, color: "black"}}
      %Game{ :player2 => nil } ->
        newgame = %{game | player2: %Player{name: playerName, color: "white"}}
        newgame = %{game | inProgress: true}
      true -> game
    end
  end


#  @doc """
#  Marks the square that has the given `phrase` for the given `player`,
#  updates the scores, and checks for a bingo!
#  """
#  def mark(game, phrase, player) do
#    game
#    |> update_squares_with_mark(phrase, player)
#    |> update_scores()
#
#    # |> assign_winner_if_bingo(player)
#  end
#
#  defp update_squares_with_mark(game, phrase, player) do
#    new_squares =
#      game.squares
#      |> List.flatten()
#      |> Enum.map(&mark_square_having_phrase(&1, phrase, player))
#      |> Enum.chunk_every(Enum.count(game.squares))
#
#    %{game | squares: new_squares}
#  end
#
#  defp mark_square_having_phrase(square, phrase, player) do
#    case square.phrase == phrase do
#      true -> %Square{square | marked_by: player}
#      false -> square
#    end
#  end
#
#  defp update_scores(game) do
#    scores =
#      game.squares
#      |> List.flatten()
#      |> Enum.reject(&is_nil(&1.marked_by))
#      |> Enum.map(fn s -> {s.marked_by.name, s.points} end)
#      |> Enum.reduce(
#           %{},
#           fn {name, points}, scores ->
#             Map.update(scores, name, points, &(&1 + points))
#           end
#         )
#
#    %{game | scores: scores}
#  end
end
