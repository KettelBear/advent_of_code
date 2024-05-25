defmodule Advent.Day.Five do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!()
    |> do_part_1()
    |> tally_hot_zones()
  end

  defp do_part_1(lines, hydro_map \\ %{})
  defp do_part_1([], hydro_map), do: hydro_map
  defp do_part_1([line | rest], hydro_map) do
    [x1, y1, x2, y2] = parse_line_ends(line)

    cond do
      x1 == x2 -> do_part_1(rest, handle_vertical(hydro_map, x1, y1, y2))
      y1 == y2 -> do_part_1(rest, handle_horizontal(hydro_map, y1, x1, x2))
      true -> do_part_1(rest, hydro_map)
    end
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!()
    |> do_part_2()
    |> tally_hot_zones()
  end

  defp do_part_2(lines, hydro_map \\ %{})
  defp do_part_2([], hydro_map), do: hydro_map
  defp do_part_2([line | rest], hydro_map) do
    [x1, y1, x2, y2] = parse_line_ends(line)

    cond do
      x1 == x2 -> do_part_2(rest, handle_vertical(hydro_map, x1, y1, y2))
      y1 == y2 -> do_part_2(rest, handle_horizontal(hydro_map, y1, x1, x2))
      true -> do_part_2(rest, handle_diagonal(hydro_map, x1, y1, x2, y2))
    end
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp parse_line_ends(line), do: line |> String.split([",", " -> "]) |> Enum.map(&stoi/1)

  defp handle_vertical(map, x, y1, y2) do
    Enum.reduce(y1..y2, map, fn y, acc ->
      Map.update(acc, {x, y}, 1, &(&1 + 1))
    end)
  end

  defp handle_horizontal(map, y, x1, x2) do
    Enum.reduce(x1..x2, map, fn x, acc ->
      Map.update(acc, {x, y}, 1, &(&1 + 1))
    end)
  end

  defp handle_diagonal(map, x1, y1, x2, y2) do
    Enum.zip(x1..x2, y1..y2)
    |> Enum.reduce(map, fn point, acc ->
      Map.update(acc, point, 1, &(&1 + 1))
    end)
  end

  defp tally_hot_zones(map) do
    map
    |> Map.values()
    |> Enum.count(&(&1 > 1))
  end
end
