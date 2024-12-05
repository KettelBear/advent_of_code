defmodule Advent.Day.One do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(multi: false, graphemes: true)
    |> Enum.frequencies()
    |> then(fn %{"(" => up, ")" => down} -> up - down end)
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(multi: false, graphemes: true)
    |> Enum.reduce_while({0, 0}, fn
      _paren, {position, -1} -> {:halt, position}
      "(", {pos, fl} -> {:cont, {pos + 1, fl + 1}}
      ")", {pos, fl} -> {:cont, {pos + 1, fl - 1}}
    end)
  end
end
