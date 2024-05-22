defmodule Advent.Day.Fourteen do
  @moduledoc false

  alias Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(split: " -> ")
    |> generate_map()
    |> drip_sand(0, &settle/2)
  end

  defp settle(map, lowest), do: settle({500, 0}, map, lowest)
  defp settle({_, y} = pos, map, lowest) do
    [down, down_left, down_right] = get_drops(pos)

    cond do
      y > lowest -> {:no, map}
      Map.get(map, down) == nil -> settle(down, map, lowest)
      Map.get(map, down_left) == nil -> settle(down_left, map, lowest)
      Map.get(map, down_right) == nil -> settle(down_right, map, lowest)
      true -> {:yes, Map.put(map, pos, "+")}
    end
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(split: " -> ")
    |> generate_map()
    |> drip_sand(2, &inf_floor/2)
  end

  defp inf_floor(map, lowest), do: inf_floor({500, 0}, map, lowest)
  defp inf_floor({_, y} = pos, map, lowest) do
    [down, down_left, down_right] = get_drops(pos)

    cond do
      y == lowest - 1 -> {:yes, Map.put(map, pos, "+")}
      Map.get(map, {500, 0}) == "+" -> {:no, map}
      Map.get(map, down) == nil -> inf_floor(down, map, lowest)
      Map.get(map, down_left) == nil -> inf_floor(down_left, map, lowest)
      Map.get(map, down_right) == nil -> inf_floor(down_right, map, lowest)
      true -> {:yes, Map.put(map, pos, "+")}
    end
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp drip_sand(rock_map, floor_diff, settle_func) do
    {{_, lowest}, _} = Enum.max_by(rock_map, fn {{_, y}, _} -> y end)

    lowest = lowest + floor_diff

    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while(rock_map, fn grain, map ->
      case settle_func.(map, lowest) do
        {:yes, map} -> {:cont, map}
        {:no, _} -> {:halt, grain - 1}
      end
    end)
  end

  defp get_drops({x, y}) do
    [{x, y + 1}, {x - 1, y + 1}, {x + 1, y + 1}]
  end

  defp generate_map(moves) do
    moves
    |> Enum.reduce(%{}, fn ranges, map ->
      ranges
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(map, fn [one, two], m ->
        [x1, y1] = get_coord(one)
        [x2, y2] = get_coord(two)
        for x <- x1..x2, y <- y1..y2, into: %{} do
          {{x, y}, "#"}
        end
        |> Map.merge(m)
      end)
    end)
  end

  defp get_coord(pair) do
    pair |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)
  end
end
