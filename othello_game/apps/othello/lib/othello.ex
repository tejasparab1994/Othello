defmodule Othello do
  use Application

  # remove buzzwordcache, think of game structure...how its gonna be built
  # hint-> battleship and othello code
  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Othello.GameRegistry},
      Othello.GameSupervisor
    ]

    # creates a table which stores all the games(their states) and to be used
    # in case a game server process crashes.
    # games_table is the name
    # public option grants read and write access to all the processes
    # named_table option allows to access table directly by its name
    # ets table is a key-value pair set, where key is the game name and value is
    # the state of the game(every key will have only one value)
    :ets.new(:games_table, [:public, :named_table])

    opts = [strategy: :one_for_one, name: Othello.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
