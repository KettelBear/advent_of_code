defmodule Advent.Day.Eight do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: " | ")
    |> Enum.reduce(0, fn [_input, output], acc ->
      output
      |> String.split(" ", trim: true)
      |> Enum.count(fn code -> String.length(code) in [2, 3, 4, 7] end)
      |> Kernel.+(acc)
    end)
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: " | ")
    |> decode_wires()
    |> sum_outputs()
  end

  defp sum_outputs(codes) do
    Enum.reduce(codes, 0, fn {decoded, outs}, acc ->
      inverted = Map.new(decoded, fn {key, value} -> {value, key} end)

      outs
      |> Enum.map(&Map.get(inverted, &1))
      |> Enum.join()
      |> stoi()
      |> Kernel.+(acc)
    end)
  end

  defp decode_wires(inputs) do
    inputs
    |> Enum.map(&split_sort/1)
    |> Enum.map(fn {input, output} -> {decode(input), output} end)
  end

  defp split_sort([input, output]) do
    {
      input |> String.split(" ", trim: true) |> Enum.map(&sort_codes/1),
      output |> String.split(" ", trim: true) |> Enum.map(&sort_codes/1)
    }
  end

  defp sort_codes(code), do: code |> String.graphemes() |> Enum.sort() |> Enum.join()

  defp decode(input) do
    digit_map =
      Enum.reduce(input, %{}, fn value, acc ->
        case String.length(value) do
          2 -> Map.put(acc, 1, value)
          3 -> Map.put(acc, 7, value)
          4 -> Map.put(acc, 4, value)
          7 -> Map.put(acc, 8, value)
          _ -> acc
        end
      end)

    Enum.reduce(input, digit_map, fn value, acc ->
      case String.length(value) do
        5 -> handle_five(value, acc)
        6 -> handle_six(value, acc)
        _ -> acc
      end
    end)
  end

  defp handle_five(value, acc) do
    cond do
      diff(Map.get(acc, 1), value) == 3 -> Map.put(acc, 3, value)
      diff(Map.get(acc, 4), value) == 2 -> Map.put(acc, 5, value)
      true -> Map.put(acc, 2, value)
    end
  end

  defp handle_six(value, acc) do
    cond do
      same(Map.get(acc, 1), value) == 1 -> Map.put(acc, 6, value)
      same(Map.get(acc, 4), value) == 4 -> Map.put(acc, 9, value)
      true -> Map.put(acc, 0, value)
    end
  end

  defp diff(known, unknown) do
    unknown
    |> String.graphemes()
    |> Kernel.--(String.graphemes(known))
    |> Enum.count()
  end

  defp same(known, unknown) do
    unknown
    |> get_charset()
    |> MapSet.intersection(get_charset(known))
    |> Enum.count()
  end

  defp get_charset(str) do
    str
    |> String.graphemes()
    |> MapSet.new()
  end
end
