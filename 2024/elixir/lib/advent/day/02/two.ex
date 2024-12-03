defmodule Advent.Day.Two do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: " ", integers: true)
    |> Enum.filter(&safe?/1)
    |> Enum.count()
  end

  @doc """
  This uses a brute force solution by removing each index and checking
  each list with the removed index. If m is the number of lines and n is
  the length of each line, this current solution is O(m * n^2) which is
  very, very gross. This _seems_ like a potential dynamic programming
  problem because of this one challenging test case:

      17 20 23 21 22 23 24

  The aforementioned list is a valid list, however, it is tricky because
  the first 23 needs to be dropped, but 20 to 23 is a valid step. So the
  challenge is to ignore a valid step because it makes an invalid line,
  but dropping that valid step makes the line valid.
  """
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: " ", integers: true)
    |> Stream.filter(fn line ->
      0..length(line) - 1
      |> Stream.map(fn index -> line |> List.delete_at(index) |> safe?() end)
      |> Enum.any?()
    end)
    |> Enum.count()
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp safe?([a, b | _rest] = data) do
    cond do
      a > b -> data
      b > a -> Enum.reverse(data)
      true -> []
    end
    |> increments_safely?()
  end

  defp increments_safely?([]), do: false
  defp increments_safely?([_last]), do: true
  defp increments_safely?([a, b | rest]) do
    if a - b in 1..3, do: increments_safely?([b | rest]), else: false
  end
end
