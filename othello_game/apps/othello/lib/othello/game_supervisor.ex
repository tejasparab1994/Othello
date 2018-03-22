defmodule Othello.GameSupervisor do
  @moduledoc """
  A supervisor that starts `GameServer` processes dynamically.
  """

  use DynamicSupervisor

  alias Othello.GameServer
  alias OthelloHallWeb.LobbyChannel

  def start_link(_arg) do
    DynamicSupervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end

  @doc """
  Starts a `GameServer` process and supervises it.
  """
  def start_game(game_name) do
    DynamicSupervisor.start_child(__MODULE__, {GameServer, [game_name]})
  end

  @doc """
  Terminates the `GameServer` process normally. It won't be restarted.
  """
  def stop_game(game_name) do
    # deletes the game from the ets table
    :ets.delete(:games_table, game_name)

    child_pid = GameServer.game_pid(game_name)
    DynamicSupervisor.terminate_child(__MODULE__, child_pid)
  end

  @doc """
  gives the list of game names being supervised by the Gamesupervisor
  """
  #  def game_names do
  #    DynamicSupervisor.which_children(__MODULE__)
  #    |> Enum.map(fn {_, game_pid, _, _} ->
  #      Registry.keys(Othello.GameRegistry, game_pid) |> List.first()
  #    end)
  #    |> Enum.sort()
  #  end

  def game_names do
    DynamicSupervisor.which_children(__MODULE__)
    |> Enum.map(fn {_, game_pid, _, _} ->
      keys = Registry.keys(Othello.GameRegistry, game_pid)
      # IO.inspect(keys)
      game_name = keys |> List.first()
      # IO.inspect(game_name)
      [{^game_name, game}] = :ets.lookup(:games_table, game_name)
      %{name: game_name, inProgress: game.inProgress}
    end)
    |> Enum.sort()
  end
end
