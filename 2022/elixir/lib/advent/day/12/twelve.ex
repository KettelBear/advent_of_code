defmodule Advent.Day.Twelve do
  @moduledoc false

  defdelegate indicies(enumerable, offset \\ 0), to: Enum, as: :with_index

  alias Advent.Utility

  @upper_s -13
  @upper_e -27

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(charlist: true)
    |> to_grid()
    |> find_start()
    |> pathfind()
  end

  defp find_start(grid) do
    start = Enum.find(grid, fn {_, position} -> position == 0 end)
    finish = Enum.find(grid, fn {_, position} -> position == 27 end)

    {grid, start, finish |> elem(0)}
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(charlist: true)
    |> to_grid()
    |> possible_starts()
    |> then(fn {grid, starts, finish} ->
      Enum.map(starts, &pathfind({grid, &1, finish}))
    end)
    |> Enum.min()
  end

  defp possible_starts(grid) do
    starts = collect_starting_points(grid)
    finish = Enum.find(grid, fn {_, position} -> position == 27 end)

    {grid, starts, finish |> elem(0)}
  end

  defp collect_starting_points(grid) do
    grid
    |> Enum.filter(fn {_point, elevation} -> elevation == 1 end)
    |> Enum.map(fn {point, _elevation} -> {point, 0} end)
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp to_grid(charlists) do
    # Turn heights into actual numbers instead of letters.
    grid = Enum.map(charlists, fn chars -> Enum.map(chars, &(&1 - ?a + 1)) end)

    for {line, row} <- indicies(grid), {h, col} <- indicies(line), into: %{} do
      cond do
        h == @upper_s -> {{row, col}, 0}
        h == @upper_e -> {{row, col}, 27}
        true -> {{row, col}, h}
      end
    end
  end

  defp pathfind({grid, start, finish}) do
    # Set all costs to infinity to start
    costs = grid |> Map.keys() |> Enum.map(&({&1, Infinity})) |> Map.new()

    pathfind([start], grid, finish, costs)
  end

  # The empty case means we never found 'E'. Observing the input data, many of
  # the 'a' starting points do not touch 'b', which is a requirement of the
  # problem.
  defp pathfind([], _map, _dest, _costs), do: Infinity
  defp pathfind([{node, cost} | remaining], map, destination, costs) do
    if node == destination do
      cost
    else
      neighbors = get_neighbors(map, node) |> Map.keys()

      {q, costs} = add_to_queue(neighbors, remaining, costs, cost)

      prioritized_q = Enum.sort_by(q, fn {{x, y}, cost} -> {cost, x, y} end)

      pathfind(prioritized_q, map, destination, costs)
    end
  end

  defp add_to_queue(neighbors, remaining, costs, cost) do
    Enum.reduce(
      neighbors,
      {remaining, costs},
      fn point, {q_acc, cost_acc} = acc ->
        new_cost = cost + 1

        if new_cost < Map.get(costs, point) do
          {[{point, new_cost} | q_acc], Map.put(cost_acc, point, new_cost)}
        else
          acc
        end
      end
    )
  end

  defp get_neighbors(map, {x, y} = p) do
    elevation = Map.get(map, p)
    moves = [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]

    Enum.reduce(moves, %{}, fn {dx, dy}, acc ->
      point = {x + dx, y + dy}
      case Map.get(map, point) do
        nil ->
          acc

        # Apparently you can step down more than one without climbing gear.
        val when val in 1..elevation+1 ->
          Map.put(acc, point, val)

        _ ->
          acc
      end
    end)
  end
end
