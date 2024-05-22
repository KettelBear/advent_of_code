defmodule Advent.Day.Four do
  @moduledoc false

  alias Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(split: ",")
    |> Enum.count(&encapsulate/1)
  end

  defp encapsulate([assignment_one, assignment_two]) do
    [a_1, b_1] = get_range(assignment_one)
    [a_2, b_2] = get_range(assignment_two)

    (a_1 <= a_2 and b_2 <= b_1) or (a_2 <= a_1 and b_1 <= b_2)
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(split: ",")
    |> Enum.count(&overlap/1)
  end

  defp overlap([assignment_one, assignment_two]) do
    [a_1, b_1] = get_range(assignment_one)
    [a_2, b_2] = get_range(assignment_two)

    b_1 >= a_2 and b_2 >= a_1
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp get_range(range_as_string) do
    range_as_string |> String.split("-") |> Enum.map(&String.to_integer/1)
  end
end
