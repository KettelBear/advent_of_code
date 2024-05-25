defmodule Advent.Day.Thirteen do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    [points, instructions] = parse_input!("#{__DIR__}/input.test", double: true)

    instructions
    |> parse_instructions()
    |> Enum.take(1)
    |> Enum.reduce(draw_points(points), fn {dir, line}, paper ->
      Enum.map(paper, fold(dir, line))
    end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp draw_points(points) do
    points
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(fn [x, y] -> {stoi(x), stoi(y)} end)
  end

  @doc false
  def part2 do
    [points, instructions] = parse_input!("#{__DIR__}/input.test", double: true)

    instructions
    |> parse_instructions()
    |> Enum.reduce(draw_points(points), fn {dir, line}, paper ->
      Enum.map(paper, fold(dir, line))
    end)
    |> draw(false)
  end

  defp draw(folded, output?) do
    {width, _} = Enum.max_by(folded, &elem(&1, 0))
    {_, height} = Enum.max_by(folded, &elem(&1, 1))

    grid = MapSet.new(folded)

    if output? do
      for y <- 0..height do
        for x <- 0..width do
          if {x, y} in grid, do: IO.write("\u2588"), else: IO.write(" ")
        end
        IO.write("\n")
      end
    else
      [:ok]
    end
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp parse_instructions(instructions) do
    instructions
    |> Enum.map(fn "fold along " <> instruction -> String.split(instruction, "=") end)
    |> Enum.map(fn [dir, line] -> {dir, stoi(line)} end)
  end

  defp fold("x", line), do: fn {x, y} -> {line - abs(x - line), y} end
  defp fold("y", line), do: fn {x, y} -> {x, line - abs(y - line)} end
end
