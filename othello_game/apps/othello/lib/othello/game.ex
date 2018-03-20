defmodule Othello.Game do
  @enforce_keys [:squares]
  defstruct squares: nil,
            scores: %{},
            winner: nil,
            inProgress: false,
            player1: nil,
            player2: nil

  alias Othello.{Game, Square, Player}

  def new do
    squareBlack = Square.new("black")
    squareWhite = Square.new("white")
    squares = Square.new()
              |> List.duplicate(8)
              |> Enum.with_index
              |> Enum.map(fn ({square, j}) -> %{square | j: j}  end)

    squares = squares
              |> List.duplicate(8)
              |> Enum.with_index
              |> Enum.map(
                   fn ({squareRow, i}) -> Enum.with_index(squareRow)
                                          |> Enum.map(fn ({square, j}) -> %{square | i: i} end)
                   end
                 )

    %Game{squares: squares}
  end

  def assign_player(game, playerName) do
    newgame = case game do
      %Game{:player1 => nil} ->
        %{
          game |
          player1: %Player{
            name: playerName,
            color: "black"
          }
        }
      %Game{:player2 => nil} ->
        newgame = %{
          game |
          player2: %Player{
            name: playerName,
            color: "white"
          }
        }
        newgame = %{game | inProgress: true}
      true ->
        game
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
