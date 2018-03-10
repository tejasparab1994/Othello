defmodule Othello do
  use Application

  def start(_type, _args) do
    children = [
      {Registry, keys: :unique, name: Othello.GameRegistry},
      Othello.BuzzwordCache,
      Othello.GameSupervisor
    ]

    :ets.new(:games_table, [:public, :named_table])

    opts = [strategy: :one_for_one, name: Othello.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
