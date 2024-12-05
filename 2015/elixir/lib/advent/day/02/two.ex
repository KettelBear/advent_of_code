defmodule Advent.Day.Two do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: "x", integers: true)
    |> Enum.map(&Enum.sort/1)
    |> Enum.reduce(0, fn [s, m, l], sqft ->
      sqft + 3*s*m + 2*s*l + 2*m*l
    end)
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: "x", integers: true)
    |> Enum.map(&Enum.sort/1)
    |> Enum.reduce(0, fn [s, m, l], sqft ->
      sqft + 2*s + 2*m + s*m*l
    end)
  end
end
