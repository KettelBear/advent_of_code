defmodule Advent.Day.Six do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: [": ", " "])
    |> format_numbers()
    |> Enum.zip()
    |> Enum.map(fn {time, dist} -> wins(time, dist) end)
    |> Enum.product()
  end

  defp format_numbers(lists) do
    lists
    |> Stream.map(&tl/1)
    |> Stream.map(fn list -> Stream.map(list, &stoi/1) end)
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: [": ", " "])
    |> format_number()
    |> then(fn [time, dist] -> wins(time, dist) end)
  end

  defp format_number(lists) do
    lists
    |> Stream.map(&tl/1)
    |> Stream.map(&Enum.join/1)
    |> Enum.map(&stoi/1)
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp wins(time, dist) do
    del = :math.sqrt(time ** 2 - 4 * (dist + 1))
    trunc(floor((time + del) / 2) - ceil((time - del) / 2)) + 1
  end
end
