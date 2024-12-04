defmodule Advent.Day.Four do
  @moduledoc false

  import Advent.Utility

  @directions [
    {-1, -1}, # Lef Up
    {-1,  0}, # Left
    {-1,  1}, # Left Down

    {0, -1}, # Up
    {0,  1}, # Down

    {1, -1}, # Right Up
    {1,  0}, # Right
    {1,  1}  # Right Down
  ]

  @doc false
  def part1 do
    grid = "#{__DIR__}/input.test" |> parse_input!(grid: true)

    Enum.reduce(grid, 0, fn
      {start, "X"}, count -> count + find_xmas(start, grid)
      _, count -> count
    end)
  end

  defp find_xmas({x, y}, grid) do
    Enum.count(@directions, fn {dx, dy} ->
      Enum.reduce(1..3, "", fn m, acc ->
        acc <> Map.get(grid, {x + (dx * m), y + (dy * m)}, "")
      end)
      # "X" was already found
      |> String.equivalent?("MAS")
    end)
  end

  @doc false
  def part2 do
    grid = "#{__DIR__}/input.test" |> parse_input!(grid: true)

    Enum.count(grid, fn
      {point, "A"} -> find_x_mas(point, grid)
      _ -> false
    end)
  end

  defp find_x_mas({x, y} = point, grid) do
    case Map.get(grid, {x - 1, y - 1}) do
      "M" ->
        Map.get(grid, {x + 1, y + 1}) == "S" and other?(point, grid)

      "S" ->
        Map.get(grid, {x + 1, y + 1}) == "M" and other?(point, grid)

      _ ->
       false
    end
  end

  defp other?({x, y}, grid) do
    [Map.get(grid, {x - 1, y + 1}), Map.get(grid, {x + 1, y - 1})] in [["M", "S"], ["S", "M"]]
  end
end
