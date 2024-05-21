defmodule Advent.Day.Five do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    [[seeds] | maps] = parse_input!("#{__DIR__}/input.test", double: true)

    seeds
    |> parse_seed_numbers()
    |> Enum.map(&follow_maps(&1, maps))
    |> Enum.min()
  end

  defp follow_maps(seed, maps) do
    Enum.reduce(maps, seed, fn [_header | nums] = _map, seed ->
      Enum.reduce_while(nums, seed, fn num_str, seed ->
        [dest, source, range] = parse_map(num_str)
        if seed in (source..(source+range-1)) do
          {:halt, seed - source + dest}
        else
          {:cont, seed}
        end
      end)
    end)
  end

  @doc false
  def part2 do
    [[seeds] | maps] = parse_input!("#{__DIR__}/input.test", double: true)

    seeds
    |> parse_seed_numbers()
    |> Enum.chunk_every(2)
    |> seed_ranges(maps)

    46
  end

  defp seed_ranges([], _), do: []
  defp seed_ranges([[start, range] | rest], maps) do
    finish = start + range - 1
    Enum.reduce(maps, [{start, finish}], fn [_header | nums], ranges ->
      nums |> Enum.map(&parse_map/1) |> follow(ranges)
    end)
    [seed_ranges(rest, maps)]
  end

  defp follow(_map, nil), do: [] # DELETE THIS
  defp follow(_map, []), do: []
  defp follow(_map, [{_start, _finish} | _rest]) do
    # TODO: Start here
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp parse_seed_numbers(seed_str) do
    seed_str
    |> split([":", " "])
    |> tl()
    |> Enum.map(&stoi/1)
  end

  defp parse_map(map_str) do
    split(map_str, " ") |> Enum.map(&stoi/1)
  end
end
