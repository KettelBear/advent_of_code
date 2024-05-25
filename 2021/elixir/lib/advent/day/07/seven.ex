defmodule Advent.Day.Seven do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: ",", integers: true, multi: false)
    |> calculate_fuel(&sum_fuel/2)
    |> Enum.min()
  end

  defp sum_fuel(distance, positions) do
    Enum.reduce(positions, 0, fn value, acc ->
      acc + abs(value - distance)
    end)
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: ",", integers: true, multi: false)
    |> calculate_fuel(&sum_of_nums_fuel/2)
    |> Enum.min()
  end

  defp sum_of_nums_fuel(distance, positions) do
    Enum.reduce(positions, 0, fn value, acc ->
      acc + ((abs(value - distance) * (abs(value - distance) + 1)) / 2)
    end)
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp calculate_fuel(positions, cost_fn) do
    Enum.min(positions)..Enum.max(positions)
    |> Enum.map(&cost_fn.(&1, positions))
  end
end
