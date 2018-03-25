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
                      %{:i => 3, :j => 3} ->
                        %{square | i: i, color: "white"}

                      %{:i => 3, :j => 4} ->
                        %{square | i: i, color: "black"}

                      %{:i => 4, :j => 3} ->
                        %{square | i: i, color: "black"}

                      %{:i => 4, :j => 4} ->
                        %{square | i: i, color: "white"}

                      %{:i => 2, :j => 3} ->
                        %{square | i: i, disabled: false}

                      #            %{:i => 2, :j => 4} ->
                      #              %{square | i: i, disabled: false}

                      %{:i => 3, :j => 2} ->
                        %{square | i: i, disabled: false}

                      #            %{:i => 4, :j => 2} ->
                      #              %{square | i: i, disabled: false}

                      %{:i => 5, :j => 4} ->
                        %{square | i: i, disabled: false}

                      %{:i => 4, :j => 5} ->
                        %{square | i: i, disabled: false}

                      _ ->
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
          player1 = %Player{
            name: playerName,
            color: "black",
            score: 2
          }

          %{
            game
          |
            player1: player1,
            next_turn: player1
          }

        %Game{:player2 => nil} ->
          %Game{:player1 => player1} = game
          player1 = %{player1 | score: 2}
          %{
            game
          |
            player2: %Player{
              name: playerName,
              color: "white",
              score: 2
            },
            inProgress: true,
          }
        _ ->
          game
      end

    newgame
  end

  def mark_square(game, playerName, i, j) do

    # First mark the squares.
    # Put the disabled tag to true for the all the squares that have not been marked
    #    new_squares =
    #      game.squares
    #      |> Enum.with_index()
    #      |> Enum.map(
    #           fn {squareRow, x} ->
    #             Enum.with_index(squareRow)
    #             |> Enum.map(
    #                  fn {square, y} ->
    #                    case square do
    #                      %Square{:i => ^i, :j => ^j, disabled: false} ->
    #                        %{square | color: game.next_turn.color, disabled: true}
    #                      %Square{disabled: false} -> %{square | disabled: true}
    #                      _ -> square
    #                    end
    #                  end
    #                )
    #           end
    #         )

    new_squares =
      game.squares
      |> Enum.map(
           fn squareRow ->
             squareRow
             |> Enum.map(
                  fn square ->
                    case square do
                      %Square{:i => ^i, :j => ^j, disabled: false} ->
                        %{square | color: game.next_turn.color, disabled: true}
                      %Square{disabled: false} -> %{square | disabled: true}
                      _ -> square
                    end
                  end
                )
           end
         )

    #    possible_directions = possible_directions(game.squares, i, j, game.next_turn.color)
    #    direction = for(row <- -1..1, col <- -1..1, do: [row, col])
    #                |> List.delete([0, 0])
    #
    #    possible_directions = Enum.filter(
    #      direction,
    #      fn ([x, y]) -> is_possible_direction(game.squares, [x, y], i, j, game.next_turn.color)
    #      end
    #    )

    reverse_color_coordinates = reverse_color_coordinates(game.squares, i, j, game.next_turn.color)
    #    reverse_color_coordinates = Enum.reduce(
    #      possible_directions,
    #      [[]],
    #      fn (possible_direction, acc) ->
    #        Enum.concat(
    #          acc,
    #          reverse_color_coordinates(new_squares, game.next_turn.color, i, j, possible_direction)
    #        )
    #      end
    #    )

    #    new_squares = new_squares
    #                  |> Enum.with_index()
    #                  |> Enum.map(
    #                       fn {squareRow, x} ->
    #                         Enum.with_index(squareRow)
    #                         |> Enum.map(
    #                              fn {square, y} ->
    #                                if [square.i, square.j] in reverse_color_coordinates do
    #                                  %{square | color: game.next_turn.color}
    #                                else
    #                                  square
    #                                end
    #                              end
    #                            )
    #                       end
    #                     )
    # Without index
    new_squares = new_squares
                  |> Enum.map(
                       fn squareRow ->
                         squareRow
                         |> Enum.map(
                              fn square ->
                                if [square.i, square.j] in reverse_color_coordinates do
                                  %{square | color: game.next_turn.color}
                                else
                                  square
                                end
                              end
                            )
                       end
                     )

    # count the scores
    black_scores = calculate_scores(new_squares, "black")
    white_scores = calculate_scores(new_squares, "white")

    update_player1 = %{game.player1 | score: black_scores}
    update_player2 = %{game.player2 | score: white_scores}

    if black_scores + white_scores == 64 do
      if black_scores > white_scores do
        %{
          game |
          player1: update_player1,
          player2: update_player2,
          squares: new_squares,
          winner: update_player1,
          inProgress: false
        }
      else
        %{
          game |
          player1: update_player1,
          player2: update_player2,
          squares: new_squares,
          winner: update_player2,
          inProgress: false
        }
      end
    else

      next_available_moves = available_moves(new_squares, flip_color(game.next_turn.color))

      case next_available_moves do

        # If there are no turns available for the next player.
        # Search available_moves for the current turn player
        [] ->
          next_available_moves = available_moves(new_squares, game.next_turn.color)

          new_squares =
            new_squares
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
              true -> update_player1
              false -> update_player2
            end

          game = %{
            game |
            player1: update_player1,
            player2: update_player2,
            squares: new_squares,
            next_turn: next_turn
          }

        # If there are turns available for the next player
        _ ->

          new_squares =
            new_squares
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
              true -> update_player2
              false -> update_player1
            end

          game = %{
            game |
            player1: update_player1,
            player2: update_player2,
            squares: new_squares,
            next_turn: next_turn
          }
      end
    end
  end

  defp reverse_color_coordinates(squares, i, j, color) do

    possible_directions = possible_directions(squares, i, j, color)

    reverse_color_coordinates = Enum.reduce(
      possible_directions,
      [[]],
      fn (possible_direction, acc) ->
        Enum.concat(
          acc,
          reverse_color_coordinates(squares, color, i, j, possible_direction)
        )
      end
    )
  end

  # This calculates the possible directions whose square color has to be reversed.
  defp possible_directions(squares, i, j, color) do
    direction = for(row <- -1..1, col <- -1..1, do: [row, col])
                |> List.delete([0, 0])

    possible_directions = Enum.filter(
      direction,
      fn ([x, y]) -> is_possible_direction(squares, [x, y], i, j, color)
      end
    )
  end

  defp calculate_scores(squares, color) do
    Enum.reduce(
      squares,
      0,
      fn (squareRow, acc) ->
        acc + Enum.reduce(
          squareRow,
          0,
          fn (square, acc1) -> if (square.color == color) do
                                 acc1 + 1
                               else
                                 acc1
                               end
          end
        )
      end
    )
  end

  defp reverse_color_coordinates(squares, color, i, j, [x, y]) do
    1..8
    |> Enum.map(fn mul -> [x * mul, y * mul] end)
    |> Enum.map(fn [x, y] -> [i + x, j + y] end)
    |> Enum.filter(fn [x, y] -> within_bounds(x, y) end)
    |> Enum.reduce_while(
         [],
         fn ([x, y], acc) -> {:ok, squareRow} = Enum.fetch(squares, x)
                             {:ok, square} = Enum.fetch(squareRow, y)
                             if square.color == color do
                               {:halt, acc}
                             else
                               {:cont, acc ++ [[x, y]]}
                             end

         end
       )
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
                       |> Enum.filter(fn [row, col] -> within_bounds(row, col) end)

    IO.puts "Check the possible indices for i: #{i}, j: #{j}"
    IO.inspect possible_indices
    colors = Enum.reduce(
      squares,
      [],
      fn (squareRow, acc) ->

        #        color = Enum.reduce(
        #                  squareRow,
        #                  fn (square, ) -> [square.i, square.j] in possible_indices
        #                  end
        #                )
        #                |> Enum.map(fn square -> square.color end)
        #                |> Enum.at(0)

        Enum.reduce(
          squareRow,
          acc,
          fn (square, acc1) ->
            if [square.i, square.j] in possible_indices do
              last_color = List.last(acc1)
              if last_color == nil || last_color != square.color do
                acc1 ++ [square.color]
              else
                acc1
              end
            else
              acc1
            end
          end
        )
      end
    )

    #        case square do
    #          nil -> acc
    #          _ -> last_color = List.last(acc)
    #               if last_color == nil || last_color != square.color do
    #                 acc ++ [square.color]
    #               else
    #                 acc
    #               end
    #        end

    IO.puts "color:"
    IO.inspect colors

    case [row, col] do
      [1, 1] -> checkColor(colors, true, color)
      [1, -1] -> checkColor(colors, true, color)
      [1, 0] -> checkColor(colors, true, color)
      [0, 1] -> checkColor(colors, true, color)
      [-1, 1] -> checkColor(colors, false, color)
      [-1, -1] -> checkColor(colors, false, color)
      [-1, 0] -> checkColor(colors, false, color)
      [0, -1] -> checkColor(colors, false, color)
    end

    #    case Enum.at(colors, 0) do
    #      nil -> opposite_color = Enum.at(colors, -1)
    #             my_color = Enum.at(colors, -2)
    #             my_color == color && opposite_color == flip_color(color)
    #      _ -> opposite_color = Enum.at(colors, 0)
    #           my_color = Enum.at(colors, 1)
    #           my_color == color && opposite_color == flip_color(color)
    #    end
  end


  defp checkColor(colors, true, color) do
    opposite_color = Enum.at(colors, 0)
    my_color = Enum.at(colors, 1)
    my_color == color && opposite_color == flip_color(color)
  end

  defp checkColor(colors, false, color) do
    opposite_color = Enum.at(colors, -1)
    my_color = Enum.at(colors, -2)
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
