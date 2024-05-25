defmodule Advent.Day.Twelve do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: "-")
    |> generate_graph()
    |> travel()
  end

  defp travel(graph), do: travel(graph["start"], graph, MapSet.new(["start"]), ["start"], 0)
  defp travel([], _graph, _seen, _path, count), do: count
  defp travel(["end" | caves], graph, seen, path, count) do
    travel(caves, graph, seen, path, count + 1)
  end
  defp travel([cave | caves], graph, seen, path, count) do
    count =
      cond do
        cave in seen -> count
        lower?(cave) -> travel(graph[cave], graph, MapSet.put(seen, cave), [cave | path], count)
        true -> travel(graph[cave], graph, seen, [cave | path], count)
      end

    travel(caves, graph, seen, path, count)
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: "-")
    |> generate_graph()
    |> traverse()
  end

  defp traverse(graph), do: traverse(graph["start"], graph, %{"start" => 1}, ["start"], 0)
  defp traverse([], _graph, _seen, _path, count), do: count
  defp traverse(["end" | caves], graph, seen, path, count) do
    traverse(caves, graph, seen, path, count + 1)
  end
  defp traverse([cave | caves], graph, seen, path, count) do
    count =
      cond do
        two_small?(seen) and cave in Map.keys(seen) ->
          count

        lower?(cave) ->
          traverse(
            graph[cave],
            graph,
            Map.update(seen, cave, 1, &(&1 + 1)),
            [cave | path],
            count
          )

        true -> traverse(graph[cave], graph, seen, [cave | path], count)
      end

    traverse(caves, graph, seen, path, count)
  end

  defp two_small?(visited), do: 2 in Map.values(visited)

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp lower?(cave), do: Regex.match?(~r/[a-z]/, cave)

  defp generate_graph(input) do
    Enum.reduce(input, %{}, fn
      ["start", right], graph ->
        Map.update(graph, "start", [right], &[right | &1])

      [left, "start"], graph ->
        Map.update(graph, "start", [left], &[left | &1])

      ["end", right], graph ->
        Map.update(graph, right, ["end"], &["end" | &1])

      [left, "end"], graph ->
        Map.update(graph, left, ["end"], &["end" | &1])

      [left, right], graph ->
        graph
        |> Map.update(left, [right], &[right | &1])
        |> Map.update(right, [left], &[left | &1])
    end)
  end
end
