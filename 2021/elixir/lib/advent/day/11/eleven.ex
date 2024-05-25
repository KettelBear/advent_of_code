defmodule Advent.Day.Eleven do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    Enum.map_reduce(
      1..100,
      parse_input!("#{__DIR__}/input.test", grid: true),
      fn _step, octopus_map -> step(octopus_map) end
    )
    |> elem(0)
    |> Enum.sum()
  end

  @doc false
  def part2 do
    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while(
      parse_input!("#{__DIR__}/input.test", grid: true),
      fn step, octopus_map ->
        case step(octopus_map) do
          {flashes, octopus_map} when map_size(octopus_map) == flashes -> {:halt, step}
          {_flashes, octopus_map} -> {:cont, octopus_map}
        end
      end
    )
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp step(octopus_map), do: flash(Map.keys(octopus_map), octopus_map, MapSet.new())

  defp flash([], octopus_map, flashed), do: {MapSet.size(flashed), octopus_map}
  defp flash([point | points], octopus_map, flashed) do
    cond do
      is_nil(octopus_map[point]) or point in flashed ->
        flash(points, octopus_map, flashed)

      octopus_map[point] >= 9 ->
        point
        |> add_neighbors(points)
        |> flash(Map.put(octopus_map, point, 0), MapSet.put(flashed, point))

      true ->
        flash(points, Map.put(octopus_map, point, octopus_map[point] + 1), flashed)
    end
  end

  defp add_neighbors({row, col}, points) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
      | points
    ]
  end
end
