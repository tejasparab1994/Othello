defmodule Othello.Game do
  @enforce_keys [:squares]
  defstruct squares: nil,
            scores: %{},
            winner: nil,
            inProgress: false,
            player1: nil,
            player2: nil,
            next_turn: nil

  alias Othello.{Game, Square, Player}

  def new do
    squareBlack = Square.new("black")
    squareWhite = Square.new("white")
    IO.puts("inside new")
    IO.inspect(squareBlack)
    IO.inspect(squareWhite)

    squares =
      Square.new()
      |> List.duplicate(8)
      |> Enum.with_index()
      |> Enum.map(fn {square, j} -> %{square | j: j} end)

    squares =
      squares
      |> List.duplicate(8)
      |> Enum.with_index()
      |> Enum.map(
           fn {squareRow, i} ->
             Enum.with_index(squareRow)
             |> Enum.map(
                  fn {square, j} ->
                    match = %{i: i, j: j}
                    case match do
                      %{:i => 3, :j => 3} -> %{square | i: i, color: "white", disabled: true}
                      %{:i => 3, :j => 4} -> %{square | i: i, color: "black", disabled: true}
                      %{:i => 4, :j => 3} -> %{square | i: i, color: "black", disabled: true}
                      %{:i => 4, :j => 4} -> %{square | i: i, color: "white", disabled: true}
                      _ -> IO.puts "Doesn't match"
                           %{square | i: i}
                    end
                  end
                )
           end
         )

    game = %Game{squares: squares}
    IO.inspect(game)
    game
  end

  def mark_winner(game, :player1) do
    %{game | winner: game.player1 , inProgress: false}
  end

  def mark_winner(game, :player2) do
    %{game | winner: game.player2, inProgress: false}
  end

  def assign_player(game, playerName) do
    newgame =
      case game do
        %Game{:player1 => nil} ->
          %{
            game
          |
            player1: %Player{
              name: playerName,
              color: "black"
            },
            next_turn: %Player{
              name: playerName,
              color: "black"
            }
          }

        %Game{:player2 => nil} ->
          %{
            game
          |
            player2: %Player{
              name: playerName,
              color: "white"
            },
            inProgress: true
          }

        _ ->
          game
      end

    # IO.inspect(newgame)

    newgame
  end

  def mark_square(game, playerName, i, j) do
    newSquares =
      game.squares
      |> Enum.with_index()
      |> Enum.map(
           fn {squareRow, x} ->
             Enum.with_index(squareRow)
             |> Enum.map(
                  fn {square, y} ->
                    case square do
                      %Square{:i => ^i, :j => ^j} ->
                        %{square | color: game.next_turn.color}

                      _ ->
                        square
                    end
                  end
                )
           end
         )

    %{:next_turn => next_turn} = game
    %{:player1 => player1} = game
    %{:player2 => player2} = game

    next_turn =
      case Map.equal?(next_turn, player1) do
        true -> player2
        false -> player1
      end

    game = %{game | squares: newSquares, next_turn: next_turn}

    # IO.inspect(game)
    # game
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
