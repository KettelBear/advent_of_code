defmodule Advent.Day.Fourteen do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    [[[template]], rules] = parse_input!("#{__DIR__}/input.test", double: true, split: " -> ")

    solve(template, rules, 1..10)
  end

  @doc false
  def part2 do
    [[[template]], rules] = parse_input!("#{__DIR__}/input.test", double: true, split: " -> ")

    solve(template, rules, 1..40)
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp solve(template, rules, iterations) do
    chars = template |> String.graphemes() |> Enum.frequencies()

    rules = Map.new(rules, fn [a, b] -> {a, b} end)

    pairs = pairs(template)

    {min, max} =
      Enum.reduce(iterations, {chars, pairs}, fn _step, {char_freq, pair_freq} ->
        step(rules, char_freq, Enum.to_list(pair_freq), %{})
      end)
      |> elem(0)
      |> Map.values()
      |> Enum.min_max()

    max - min
  end

  defp step(_rules, char_freqs, [], pair_step), do: {char_freqs, pair_step}
  defp step(rules, char_freqs, [{pair, freq} | pairs], pair_step) do
    {char_freq, pair_step} =
      if Map.has_key?(rules, pair) do
        letter = rules[pair]
        char_freqs = Map.update(char_freqs, letter, freq, &(&1 + freq))
        pair_step =
          pair_step
          |> Map.update(String.first(pair) <> letter, freq, &(&1 + freq))
          |> Map.update(letter <> String.last(pair), freq, &(&1 + freq))
        {char_freqs, pair_step}
      else
        {char_freqs, pair_step}
      end
    step(rules, char_freq, pairs, pair_step)
  end

  defp pairs(template) do
    template
    |> String.graphemes()
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.frequencies()
    |> Enum.map(fn {[c1, c2], freq} -> {c1 <> c2, freq} end)
  end
end
