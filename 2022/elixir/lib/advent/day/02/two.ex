defmodule Advent.Day.Two do
  @moduledoc false

  alias Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(split: " ")
    |> Enum.reduce(0, &(play_game(&1) + &2))
  end

  defp play_game(["A", "X"]), do: 4
  defp play_game(["A", "Y"]), do: 8
  defp play_game(["A", "Z"]), do: 3
  defp play_game(["B", "X"]), do: 1
  defp play_game(["B", "Y"]), do: 5
  defp play_game(["B", "Z"]), do: 9
  defp play_game(["C", "X"]), do: 7
  defp play_game(["C", "Y"]), do: 2
  defp play_game(["C", "Z"]), do: 6

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(split: " ")
    |> Enum.reduce(0, &(pick_move(&1) + &2))
  end

  defp pick_move(["A", "X"]), do: 3
  defp pick_move(["A", "Y"]), do: 4
  defp pick_move(["A", "Z"]), do: 8
  defp pick_move(["B", "X"]), do: 1
  defp pick_move(["B", "Y"]), do: 5
  defp pick_move(["B", "Z"]), do: 9
  defp pick_move(["C", "X"]), do: 2
  defp pick_move(["C", "Y"]), do: 6
  defp pick_move(["C", "Z"]), do: 7
end
