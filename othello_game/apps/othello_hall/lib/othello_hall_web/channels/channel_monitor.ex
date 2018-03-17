defmodule OthelloHall.ChannelMonitor do
  use GenServer

  def start_link(initial_state) do
    GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def user_joined(channel, user) do
    GenServer.call(__MODULE__, {:user_joined, channel, user})
  end

  def users_in_channel(channel) do
    GenServer.call(__MODULE__, {:users_in_channel, channel})
  end

  def user_left(channel, user) do
    GenServer.call(__MODULE__, {:user_left, channel, user})
  end

  # --------------------------------------------------------------------------
  # GenServer implementation
  def handle_call({:user_joined, channel, user}, _from, state) do
    IO.inspect("-------STATE-------")
    IO.inspect(state)
    IO.inspect("-----Channel-------")
    IO.inspect(channel)

    new_state =
      case Map.get(state, channel) do
        nil ->
          Map.put(state, channel, [user])

        users ->
          Map.put(state, channel, Enum.uniq([user | users]))
      end

    {:reply, new_state, new_state}
  end

  def handle_call({:users_in_channel, channel}, _from, state) do
    {:reply, Map.get(state, channel), state}
  end

  # how will this work?
  def handle_call({:user_left, channel, user}, _from, state) do
    new_users =
      state
      |> Map.get(channel)
      |> Enum.reject(&(&1.name == user.name))

    if Enum.empty?(new_users) do
      new_state = Map.delete(state, channel)
    else
      new_state = Map.update!(state, channel, fn _ -> new_users end)
    end

    {:reply, new_state, new_state}
  end
end
