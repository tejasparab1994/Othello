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
    %{game | winner: game.player1, inProgress: false}
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

    newgame
  end

  def mark_square(game, playerName, i, j) do

    #    if {i, j} in available_moves(i, j, game.squares, game.next_turn.color) do
    #
    #    end

    new_squares =
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

    next_available_moves = available_moves(new_squares, flip_color(game.next_turn.color))

    new_squares =
      game.squares
      |> Enum.with_index()
      |> Enum.map(
           fn {squareRow, x} ->
             Enum.with_index(squareRow)
             |> Enum.map(
                  fn {square, y} ->
                    if {x, y} in next_available_moves do
                      %{square | disabled: false}
                    else
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

    game = %{game | squares: new_squares, next_turn: next_turn}
  end

  defp available_moves(squares, color)  do
    Enum.reduce(
      squares,
      [],
      fn (squareRow, acc1) ->
        Enum.concat(
          acc1,
          squareRow
          |> Enum.filter(fn square -> square.color == nil end)
          |> Enum.filter(fn square -> is_valid_move(squares, square.i, square.j, color) end)
          |> Enum.map(fn square -> {square.i, square.j} end)
        )
      end
    )
  end


  defp is_valid_move(squares, i, j, color) do
    traversal = for(row <- -1..1, col <- -1..1, do: [row, col])
                |> List.delete([0, 0])
    Enum.reduce(
      traversal,
      false,
      fn ([row, col], acc) ->
        acc || is_possible_direction(squares, [row, col], i, j, color)
      end
    )
  end


  defp is_possible_direction(squares, [row, col], i, j, color) do
    possible_indices = for(mul <- 1..8, do: [row * mul, col * mul])
                       |> Enum.map(fn [row, col] -> [row + i, col + j] end)
                       |> Enum.map(fn [row, col] -> within_bounds(row, col) end)

    colors = Enum.reduce(
      squares,
      [],
      fn (squareRow, acc) ->
        Enum.concat(
          acc,
          Enum.filter(
            squareRow,
            fn (square) -> [square.i, square.j] in possible_indices
            end
          )
          |> Enum.map(fn square -> square.color end)
        )
      end
    )

    opposite_color = Enum.at(colors, 0)
    my_color = Enum.at(colors, 1)

    my_color == color && opposite_color == flip_color(color)
  end

  defp within_bounds(row, col) do
    row >= 0 && row < 8 && col >= 0 && col < 8
  end

  defp flip_color(color) do
    case color do
      "black" -> "white"
      "white" -> "black"
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
