defmodule Advent.Day.Two do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: " ", integers: true)
    |> Enum.filter(&safety_filter/1)
    |> Enum.count()
  end

  defp safety_filter([a, b | _rest] = data) do
    cond do
      a > b -> data
      b > a -> Enum.reverse(data)
      true -> []
    end
    |> increment_safely()
  end

  defp increment_safely([]), do: false
  defp increment_safely([_last]), do: true
  defp increment_safely([a, b | rest]) do
    if a - b in 1..3, do: increment_safely([b | rest]), else: false
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: " ", integers: true)
    |> Enum.filter(&allow_one_mistake/1)
    #|> Enum.count()

    #list = "#{__DIR__}/input.prod" |> parse_input!(split: " ", integers: true)

    #filtered = Enum.filter(list, &allow_one_mistake/1)

    #{:ok, file} = File.open("#{__DIR__}/output.prod", [:append])
    #Enum.each(list -- filtered, &IO.binwrite(file, inspect(&1, charlists: :as_list)))
    #File.close(file)

    409
  end

  defp allow_one_mistake(data) do
    increment?(data)
      or (data |> Enum.reverse() |> increment?())
      or (data |> tl() |> increment?(false))
      or (data |> Enum.reverse() |> tl() |> increment?(false))
  end

  defp increment?(data, clean? \\ true)

  defp increment?([], _clean?), do: true
  defp increment?([_last], _clean?), do: true
  defp increment?([a, b], clean?), do: (a - b in 1..3) or clean?
  defp increment?([a, b | rest], clean?) do
    cond do
      a - b in 1..3 -> increment?([b | rest], clean?)
      clean? and a - hd(rest) in 1..3 -> increment?(rest, false)
      true -> false
    end
  end
end
