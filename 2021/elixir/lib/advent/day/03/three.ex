defmodule Advent.Day.Three do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    digits = "#{__DIR__}/input.test" |> parse_input!(graphemes: true)

    len = digits |> hd() |> Enum.count()
    gamma = for i <- 0..(len - 1), do: digits |> column(i) |> common(:most)

    (gamma |> base_ten()) * (gamma |> invert() |> base_ten())
  end

  @doc false
  def part2 do
    digits = "#{__DIR__}/input.test" |> parse_input!(graphemes: true)

    oxygen = digits |> filter_grid(&common(&1, :most)) |> base_ten()
    carbondioxide = digits |> filter_grid(&common(&1, :least)) |> base_ten()

    oxygen * carbondioxide
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp base_ten(binary_digits) do
    binary_digits
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp column(matrix, index) do
    matrix
    |> Enum.map(&Enum.at(&1, index))
    |> Enum.reject(&is_nil/1)
  end

  defp common(digits, :most) do
    %{"1" => ones, "0" => zeroes} = Enum.frequencies(digits)
    if ones >= zeroes, do: "1", else: "0"
  end
  defp common(digits, :least) do
    %{"1" => ones, "0" => zeroes} = Enum.frequencies(digits)
    if ones < zeroes, do: "1", else: "0"
  end

  defp filter_grid(digits, predicate, search_column \\ 0)
  defp filter_grid([number], _predicate, _search_column), do: number
  defp filter_grid(digits, predicate, search_column) do
    keeper = digits |> column(search_column) |> predicate.()

    digits
    |> Enum.filter(fn list -> Enum.at(list, search_column) == keeper end)
    |> filter_grid(predicate, search_column + 1)
  end

  defp invert(digits) do
    Enum.map(digits, fn one -> if one == "1", do: "0", else: "1" end)
  end
end
