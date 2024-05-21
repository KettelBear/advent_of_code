defmodule Advent.Day.One do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/p1_input.test"
    |> parse_input!(charlist: true)
    |> Enum.reduce(0, fn chars, acc ->
      first = find(chars)
      last = chars |> Enum.reverse() |> find()
      acc + (10 * first) + last
    end)
  end

  defp find(chars), do: Enum.find(chars, &(&1 in ?1..?9)) |> Kernel.-(?0)

  @doc false
  def part2 do
    "#{__DIR__}/p2_input.test"
    |> parse_input!(charlist: true)
    |> Enum.reduce(0, fn chars, acc ->
      first = find_first(chars)
      last = chars |> Enum.reverse() |> find_last()
      acc + 10 * first + last
    end)
  end

  defp find_first([?o, ?n, ?e | _]), do: 1
  defp find_first([?1 | _]), do: 1
  defp find_first([?t, ?w, ?o | _]), do: 2
  defp find_first([?2 | _]), do: 2
  defp find_first([?t, ?h, ?r, ?e, ?e | _]), do: 3
  defp find_first([?3 | _]), do: 3
  defp find_first([?f, ?o, ?u, ?r | _]), do: 4
  defp find_first([?4 | _]), do: 4
  defp find_first([?f, ?i, ?v, ?e | _]), do: 5
  defp find_first([?5 | _]), do: 5
  defp find_first([?s, ?i, ?x | _]), do: 6
  defp find_first([?6 | _]), do: 6
  defp find_first([?s, ?e, ?v, ?e, ?n | _]), do: 7
  defp find_first([?7 | _]), do: 7
  defp find_first([?e, ?i, ?g, ?h, ?t | _]), do: 8
  defp find_first([?8 | _]), do: 8
  defp find_first([?n, ?i, ?n, ?e | _]), do: 9
  defp find_first([?9 | _]), do: 9
  defp find_first([_ | rest]), do: find_first(rest)

  defp find_last([?e, ?n, ?o | _]), do: 1
  defp find_last([?1 | _]), do: 1
  defp find_last([?o, ?w, ?t | _]), do: 2
  defp find_last([?2 | _]), do: 2
  defp find_last([?e, ?e, ?r, ?h, ?t | _]), do: 3
  defp find_last([?3 | _]), do: 3
  defp find_last([?r, ?u, ?o, ?f | _]), do: 4
  defp find_last([?4 | _]), do: 4
  defp find_last([?e, ?v, ?i, ?f | _]), do: 5
  defp find_last([?5 | _]), do: 5
  defp find_last([?x, ?i, ?s | _]), do: 6
  defp find_last([?6 | _]), do: 6
  defp find_last([?n, ?e, ?v, ?e, ?s | _]), do: 7
  defp find_last([?7 | _]), do: 7
  defp find_last([?t, ?h, ?g, ?i, ?e | _]), do: 8
  defp find_last([?8 | _]), do: 8
  defp find_last([?e, ?n, ?i, ?n | _]), do: 9
  defp find_last([?9 | _]), do: 9
  defp find_last([_ | rest]), do: find_last(rest)
end
