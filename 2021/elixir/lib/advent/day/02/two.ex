defmodule Advent.Day.Two do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!()
    |> Stream.map(&directions/1)
    |> Enum.reduce({0, 0}, &drive/2)
    |> Tuple.product()
  end

  defp drive({:forward, amount}, {dist, depth}), do: {dist + amount, depth}
  defp drive({:down, amount}, {dist, depth}), do: {dist, depth + amount}
  defp drive({:up, amount}, {dist, depth}), do: {dist, depth - amount}

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!()
    |> Stream.map(&directions/1)
    |> Enum.reduce({0, 0, 0}, &aim/2)
    |> then(fn {dist, depth, _aim} -> dist * depth end)
  end

  defp aim({:forward, amount}, {dist, depth, aim}), do: {dist + amount, depth + aim * amount, aim}
  defp aim({:down, amount}, {dist, depth, aim}), do: {dist, depth, aim + amount}
  defp aim({:up, amount}, {dist, depth, aim}), do: {dist, depth, aim - amount}

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp directions("forward " <> n), do: {:forward, stoi(n)}
  defp directions("down " <> n), do: {:down, stoi(n)}
  defp directions("up " <> n), do: {:up, stoi(n)}
end
