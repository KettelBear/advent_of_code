defmodule Advent.Day.Nine do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    grid = parse_input!("#{__DIR__}/input.test", grid: true)

    grid
    |> Stream.filter(&local_minimum(grid, &1))
    |> Enum.reduce(0, fn {_, value}, acc -> acc + value + 1 end)
  end

  @doc false
  def part2 do
    grid = parse_input!("#{__DIR__}/input.test", grid: true)

    grid
    |> Stream.filter(&local_minimum(grid, &1))
    |> Stream.map(fn {point, _} -> point |> basin(grid) |> MapSet.size() end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp basin(point, grid), do: basin(MapSet.new(), point, grid)
  defp basin(set, point, grid) do
    if grid[point] in [9, nil] or point in set do
      set
    else
      point |> neighbors() |> Enum.reduce(MapSet.put(set, point), &basin(&2, &1, grid))
    end
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp local_minimum(grid, {point, value}) do
    point |> neighbors() |> Enum.all?(&(value < Map.get(grid, &1)))
  end

  defp neighbors({row, col}) do
    [{row + 1, col}, {row - 1, col}, {row, col - 1}, {row, col + 1}]
  end
end
