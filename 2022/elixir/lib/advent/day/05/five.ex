defmodule Advent.Day.Five do
  @moduledoc false

  alias Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> Utility.parse_day_five()
    |> move_crates(true)
    |> top_crates()
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> Utility.parse_day_five()
    |> move_crates(false)
    |> top_crates()
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp move_crates({stack_start, instructions}, reverse) do
    Enum.reduce(
      instructions,
      stack_start,
      fn [boxes, start, dest], columns ->
        destination = Map.get(columns, dest)

        {move, stack} = columns |> Map.get(start) |> Enum.split(boxes)

        boxes_to_move = if reverse, do: Enum.reverse(move), else: move

        columns
        |> Map.put(start, stack)
        |> Map.put(dest, boxes_to_move ++ destination)
      end
    )
  end

  defp top_crates(columns) do
    columns
    |> Enum.map(fn {_, [crate | _]} -> crate end)
    |> Enum.join()
  end
end
