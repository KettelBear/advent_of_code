defmodule Advent.Day.Eight do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    {steps, graph} = parse_day8_input!("#{__DIR__}/input_two.test")

    traverse("AAA", steps, steps, graph)
  end

  defp traverse("ZZZ", _steps, _step_list, _graph), do: 0
  defp traverse(curr_node, [], step_list, graph) do
    traverse(curr_node, step_list, step_list, graph)
  end
  defp traverse(curr_node, ["L" | steps], step_list, graph) do
    1 + traverse(Map.get(graph, curr_node) |> elem(0), steps, step_list, graph)
  end
  defp traverse(curr_node, ["R" | steps], step_list, graph) do
    1 + traverse(Map.get(graph, curr_node) |> elem(1), steps, step_list, graph)
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

  defp parse_day8_input!(file_path) do
    [[instructions] | [nodes]] = parse_input!(file_path, double: true)
    graph = split(nodes, " = ") |> graph_it(%{})

    {String.graphemes(instructions), graph}
  end

  defp graph_it([], graph), do: graph
  defp graph_it([[start, left_right_str] | rest], graph) do
    left_right_tuple = translate_left_right(left_right_str)
    graph_it(rest, Map.put(graph, start, left_right_tuple))
  end

  defp translate_left_right(str) do
    [left, right] = split(str, ", ")

    {String.replace(left, "(", ""), String.replace(right, ")", "")}
  end
end
