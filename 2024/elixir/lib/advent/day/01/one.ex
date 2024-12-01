defmodule Advent.Day.One do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: " ", integers: true)
    |> Enum.reduce({[], []}, fn [a, b], {l1, l2} -> {[a | l1], [b | l2]} end)
    |> sum_diffs()
  end

  defp sum_diffs({l1, l2}), do: sum_diffs(Enum.sort(l1), Enum.sort(l2))
  defp sum_diffs([], []), do: 0
  defp sum_diffs([n1 | l1], [n2 | l2]), do: abs(n1 - n2) + sum_diffs(l1, l2)

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: " ", integers: true)
    |> Enum.reduce({[], []}, fn [a, b], {l1, l2} -> {[a | l1], [b | l2]} end)
    |> freqs()
    |> sum_freq_multiplier()
  end

  defp freqs({l1, l2}), do: {l1, Enum.frequencies(l2)}

  defp sum_freq_multiplier({l1, freqs}) do
    Enum.reduce(l1, 0, fn num, sum -> sum + (num * Map.get(freqs, num, 0)) end)
  end
end
