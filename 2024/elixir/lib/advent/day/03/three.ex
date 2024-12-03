defmodule Advent.Day.Three do
  @moduledoc false

  import Advent.Utility

  @part_one_input "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"

  @doc false
  def part1 do
    ~r/mul\(\d{1,3},\d{1,3}\)/
    |> Regex.scan(@part_one_input)
    |> Enum.reduce(0, fn ["mul" <> rest], sum ->
      [n1, n2] = String.split(rest, ["(", ",", ")"], trim: true)
      sum + stoi(n1) * stoi(n2)
    end)
  end

  @part_two_input "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"

  @doc false
  def part2 do
    ~r/mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\)/
    |> Regex.scan(@part_two_input)
    |> Enum.reduce({0, true}, fn
      ["mul" <> rest], {sum, true} ->
        [n1, n2] = String.split(rest, ["(", ",", ")"], trim: true)
        {sum + stoi(n1) * stoi(n2), true}

      ["mul" <> _rest], acc ->
        acc

      ["do()"], {sum, _} ->
        {sum, true}

      ["don't()"], {sum, _} ->
        {sum, false}
    end)
    |> elem(0)
  end
end
