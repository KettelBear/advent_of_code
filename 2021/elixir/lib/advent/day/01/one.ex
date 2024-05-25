defmodule Advent.Day.One do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(integers: true)
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> b > a end)
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(integers: true)
    |> Stream.chunk_every(4, 1, :discard)
    |> Enum.count(fn [a, _, _, d] -> d > a end)
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################
end
