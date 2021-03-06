defmodule Othello.GameServer do
  @moduledoc """
  A game server process that holds a `Game` struct as its state.
  """
  use GenServer

  require Logger

  @timeout :timer.hours(2)

  # Client (Public) Interface

  def child_spec(arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, arg},
      restart: :transient
    }
  end

  @doc """
  Spawns a new game server process registered under the given `game_name`.
  """
  def start_link(game_name) do
    size = 8
    GenServer.start_link(__MODULE__, {game_name, size}, name: via_tuple(game_name))
  end

  def summary(game_name) do
    GenServer.call(via_tuple(game_name), :summary)
  end

  def declare_winner(game_name, :player2) do
    GenServer.call(via_tuple(game_name), {:mark_winner, :player2})
  end

  def declare_winner(game_name, :player1) do
    GenServer.call(via_tuple(game_name), {:mark_winner, :player1})
  end

  def assign_player(game_name, playerName) do
    GenServer.call(via_tuple(game_name), {:assign_player, playerName})
  end

  def mark_square(game_name, playerName, i, j) do
    GenServer.call(via_tuple(game_name), {:mark_square, playerName, i, j})
  end

  @doc """
  Returns a tuple used to register and lookup a game server process by name.
  """
  def via_tuple(game_name) do
    {:via, Registry, {Othello.GameRegistry, game_name}}
  end

  @doc """
  Returns the `pid` of the game server process registered under the
  given `game_name`, or `nil` if no process is registered.
  """
  def game_pid(game_name) do
    game_name
    |> via_tuple()
    |> GenServer.whereis()
  end

  def init({game_name, size}) do
    game =
      case :ets.lookup(:games_table, game_name) do
        [] ->
          game = Othello.Game.new()
          :ets.insert(:games_table, {game_name, game})
          game

        [{^game_name, game}] ->
          game
      end

    Logger.info("Spawned game server process named '#{game_name}'.")

    {:ok, game, @timeout}
  end

  def handle_call(:summary, _from, game) do
    {:reply, summarize(game), game, @timeout}
  end

 def handle_call({:assign_player, playerName}, _from, game) do
    new_game = Othello.Game.assign_player(game, playerName)
    :ets.insert(:games_table, {my_game_name(), new_game})
    {:reply, summarize(new_game), new_game, @timeout}
  end

  def handle_call({:mark_winner, :player1}, _from, game) do
    new_game = Othello.Game.mark_winner(game, :player1)
    :ets.insert(:games_table, {my_game_name(), new_game})
    {:reply, summarize(new_game), new_game, @timeout}
  end

  def handle_call({:mark_winner, :player2}, _from, game) do
    new_game = Othello.Game.mark_winner(game, :player2)
    :ets.insert(:games_table, {my_game_name(), new_game})
    {:reply, summarize(new_game), new_game, @timeout}
  end

  def handle_call({:mark_square, playerName, i, j}, _from, game) do
    new_game = Othello.Game.mark_square(game, playerName, i, j)
    :ets.insert(:games_table, {my_game_name(), new_game})
    {:reply, summarize(new_game), new_game, @timeout}
  end

  def summarize(game) do
    %{
      player1: game.player1,
      player2: game.player2,
      next_turn: game.next_turn,
      squares: game.squares,
      in_progress: game.inProgress,
      winner: game.winner
    }
  end

  def handle_info(:timeout, game) do
    {:stop, {:shutdown, :timeout}, game}
  end

  def terminate({:shutdown, :timeout}, _game) do
    :ets.delete(:games_table, my_game_name())
    :ok
  end

  def terminate(_reason, _game) do
    :ok
  end

  defp my_game_name do
    Registry.keys(Othello.GameRegistry, self()) |> List.first()
  end
end
