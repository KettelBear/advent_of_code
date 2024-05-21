defmodule Advent.Day.Eight do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    {steps, graph} = parse_day8_input!("#{__DIR__}/input_two.test")

    traverse("AAA", steps, 0, steps, graph)
  end

  defp traverse("ZZZ", _steps, count, _step_list, _graph), do: count
  defp traverse(curr_node, [], count, step_list, graph) do
    traverse(curr_node, step_list, count, step_list, graph)
  end
  defp traverse(curr_node, [direction | steps], count, step_list, graph) do
    {left, right} = Map.get(graph, curr_node)

    case direction do
      "L" -> traverse(left, steps, count+1, step_list, graph)
      "R" -> traverse(right, steps, count+1, step_list, graph)
    end
  end

  @doc false
  def part2 do
    {steps, graph} = parse_day8_input!("#{__DIR__}/input_three.test")

    graph
    |> Map.keys()
    |> Enum.filter(&String.ends_with?(&1, "A"))
    |> distances(steps, graph)
    |> lcm()
  end

  defp distances([], _steps, _graph), do: []
  defp distances([start | rest], steps, graph) do
    [walk(start, steps, 0, steps, graph) | distances(rest, steps, graph)]
  end

  defp walk(curr_node, [], count, steps, graph), do: walk(curr_node, steps, count, steps, graph)
  defp walk(curr_node, [direction | rest], count, steps, graph) do
    if String.ends_with?(curr_node, "Z") do
      count
    else
      {left, right} = Map.get(graph, curr_node)

      case direction do
        "L" -> walk(left, rest, count+1, steps, graph)
        "R" -> walk(right, rest, count+1, steps, graph)
      end
    end
  end

  # The LCM of [a, b, c, ..., z] == LCM(a, b) |> LCM(c) |> ... |> LCM(z)
  defp lcm([last]), do: last
  defp lcm([one, two | rest]) do
    lcm([div((one * two), Integer.gcd(one, two)) | rest])
  end
end
