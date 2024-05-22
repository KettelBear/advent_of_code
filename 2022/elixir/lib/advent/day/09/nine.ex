defmodule Advent.Day.Nine do
  @moduledoc false

  alias Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/p1_input.test"
    |> Utility.parse_input!(split: " ")
    |> track_tail([{0, 0}, {0, 0}])
    |> Enum.count()
  end

  @doc false
  def part2 do
    "#{__DIR__}/p2_input.test"
    |> Utility.parse_input!(split: " ")
    |> track_tail(List.duplicate({0, 0}, 10))
    |> Enum.count()
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp track_tail(input, knots), do: track_tail(MapSet.new(), knots, input)
  defp track_tail(visited, _, []), do: visited
  defp track_tail(visited, knots, [[direction, steps] | instructions]) do
    steps = String.to_integer(steps)

    {knots, tail_positions} =
      for _ <- 1..steps, reduce: {knots, []} do
        {k, tls} ->
          k = follow([k |> hd() |> move(direction) | tl(k)])
          {k, [List.last(k) | tls]}
      end

    tail_positions
    |> MapSet.new()
    |> MapSet.union(visited)
    |> track_tail(knots, instructions)
  end

  defp move({x, y}, "R"), do: {x + 1, y}
  defp move({x, y}, "L"), do: {x - 1, y}
  defp move({x, y}, "U"), do: {x, y + 1}
  defp move({x, y}, "D"), do: {x, y - 1}

  defp follow([last_knot]), do: [last_knot]
  defp follow([{xh, yh} = hp, {xt, yt} = tp | rest]) do
    dx = xh - xt
    dy = yh - yt

    new_tp = cond do
      dx > 1 -> {xt + 1, yt + rnd(dy / 2)}
      dx < -1 -> {xt - 1, yt + rnd(dy / 2)}
      dy > 1 -> {xt + rnd(dx / 2), yt + 1}
      dy < -1 -> {xt + rnd(dx / 2), yt - 1}
      true -> tp
    end

    [hp | follow([new_tp | rest])]
  end

  defp rnd(number), do: if(number < 0, do: floor(number), else: ceil(number))
end
