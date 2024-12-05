defmodule Advent.Day.Five do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    [rules, updates] = "#{__DIR__}/input.test" |> parse_input!(double: true)

    updates
    |> parse_updates()
    |> Stream.filter(&valid?(&1, map_rules(rules)))
    |> Enum.reduce(0, &(middle_val(&1) + &2))
  end

  @doc false
  def part2 do
    [rules, updates] = "#{__DIR__}/input.test" |> parse_input!(double: true)

    rules_map = map_rules(rules)

    updates
    |> parse_updates()
    |> Stream.reject(&valid?(&1, rules_map))
    |> Stream.map(&fix(&1, rules_map))
    |> Enum.reduce(0, &(middle_val(&1) + &2))
  end

  defp fix([], _rules_map), do: []
  defp fix(update, rules_map) do
    {next, remaining} = List.pop_at(update, find_next(update, rules_map))
    [next | fix(remaining, rules_map)]
  end

  defp find_next(update, rules_map) do
    Enum.find_index(update, fn val ->
      Enum.all?(update, fn sub -> val == sub or sub in Map.get(rules_map, val, []) end)
    end)
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp map_rules(rules) do
    Enum.reduce(rules, %{}, fn rule, map ->
      [k, v] = String.split(rule, "|")
      Map.update(map, k, [v], &[v | &1])
    end)
  end

  defp parse_updates(updates) do
    Enum.map(updates, &String.split(&1, ","))
  end

  defp valid?([_], _rules_map), do: true
  defp valid?([u | update], rules_map) do
    case Map.get(rules_map, u) do
      nil ->
        false

      followers ->
        if Enum.all?(update, &(&1 in followers)) do
          valid?(update, rules_map)
        else
          false
        end
    end
  end

  defp middle_val(list) do
    Enum.at(list, length(list) |> div(2)) |> stoi()
  end
end
