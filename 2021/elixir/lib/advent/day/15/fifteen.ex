defmodule Advent.Day.Fifteen do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(grid: true)
    |> dijkstras()
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(graphemes: true, integers: true)
    |> expand()
    |> list_to_graph()
    |> dijkstras()
  end

  defp expand(graph) do
    for x <- 0..4, y <- 0..4 do
      x + y
    end
    |> Enum.chunk_every(5)
    |> Enum.flat_map(fn line ->
      Enum.reduce(line, [], fn level, acc ->
        new_values(graph, level)
        |> Enum.with_index()
        |> Enum.map(fn {x, index} -> Enum.at(acc, index, []) ++ x end)
      end)
    end)
  end

  defp new_values(graph, level) do
    cycle = Stream.cycle(1..9)

    graph
    |> Enum.map(fn line ->
      Enum.map(line, fn x -> Enum.at(cycle, x + level - 1) end)
    end)
  end

  defp list_to_graph(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, x}, acc ->
      row
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {value, y}, row_acc ->
        Map.put(row_acc, {x, y}, value)
      end)
    end)
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp dijkstras(graph) do
    destination = graph |> Map.keys() |> Enum.max()

    dijkstras([{{0, 0}, 0}], graph, destination, Map.new(Enum.map(Map.keys(graph), &{&1, Infinity})))
  end

  defp dijkstras([{destination, cost} | _remaining], _graph, destination, _costs), do: cost
  defp dijkstras([{node, cost} | remaining], graph, destination, costs) do
    neighbors = get_neighbors(graph, node) |> Map.keys()

    {queue, costs} =
      Enum.reduce(neighbors, {remaining, costs}, fn node, {queue_acc, cost_acc} = acc ->
        new_cost = cost + Map.get(graph, node)

        if new_cost < Map.get(costs, node) do
          {[{node, new_cost} | queue_acc], Map.put(cost_acc, node, new_cost)}
        else
          acc
        end
      end)

    dijkstras(Enum.sort_by(queue, fn {{x, y}, cost} -> {cost, x, y} end), graph, destination, costs)
  end

  defp get_neighbors(graph, {x, y}) do
    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
    |> Enum.reduce(%{}, fn {dx, dy}, acc ->
      point = {x + dx, y + dy}
      value = Map.get(graph, point)

      if value, do: Map.put(acc, point, value), else: acc
    end)
  end
end
