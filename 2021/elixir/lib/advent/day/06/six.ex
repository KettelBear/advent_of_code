defmodule Advent.Day.Six do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(multi: false, split: ",", integers: true)
    |> Enum.frequencies()
    |> simulate(80)
    |> count_population()
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(multi: false, split: ",", integers: true)
    |> Enum.frequencies()
    |> simulate(256)
    |> count_population()
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp simulate(population, 0), do: population
  defp simulate(population, days) do
    population
    |> Enum.reduce(%{}, &increment_day/2)
    |> simulate(days - 1)
  end

  defp increment_day({0, current_population}, population_map) do
    population_map
    |> Map.put(8, current_population)
    |> Map.update(6, current_population, &(&1 + current_population))
  end
  defp increment_day({timer, current_population}, population_map) do
    Map.update(population_map, timer - 1, current_population, &(&1 + current_population))
  end

  defp count_population(population_map) do
    Enum.reduce(population_map, 0, fn {_, pop}, sum -> sum + pop end)
  end
end
