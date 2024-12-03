defmodule Advent.Day.Three do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    input = "#{__DIR__}/input.test" |> parse_input!() |> hd()

    Regex.scan(~r/mul\(\d{1,3},\d{1,3}\)/, input)
    |> List.flatten()
    |> Enum.reduce(0, fn "mul" <> rest, sum ->
      [n1, n2] = String.split(rest, ["(", ",", ")"], trim: true)
      sum + stoi(n1) * stoi(n2)
    end)
  end

  @doc false
  def part2 do
    input = "#{__DIR__}/input.test2" |> parse_input!() |> hd()

    Regex.scan(~r/mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/, input)
    |> List.flatten()
    |> Enum.reduce({0, true}, fn
      "mul" <> rest, {sum, true} ->
        [n1, n2] = String.split(rest, ["(", ",", ")"], trim: true)
        {sum + stoi(n1) * stoi(n2), true}

      "mul" <> _rest, acc ->
        acc

      "do()", {sum, _} ->
        {sum, true}

      "don't()", {sum, _} ->
        {sum, false}
    end)
    |> elem(0)
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################
end
