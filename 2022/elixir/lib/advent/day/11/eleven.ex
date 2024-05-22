defmodule Advent.Day.Eleven do
  @moduledoc false

  defdelegate stoi(str), to: String, as: :to_integer

  defmodule Monkey do
    defstruct [:operation, :test, :pass, :fail, inspects: 0, items: []]
  end

  alias Advent.Day.Eleven.Monkey
  alias Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(double: true)
    |> build_monkeys()
    |> keep_away(20, false)
    |> level_of_monkey_business()
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(double: true)
    |> build_monkeys()
    |> keep_away(10_000, true)
    |> level_of_monkey_business()
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp level_of_monkey_business(monkeys) do
    monkeys
    |> Enum.sort_by(fn {_, monkey} -> monkey.inspects end, :desc)
    |> Enum.take(2)
    |> then(fn [{_, m1}, {_, m2}] -> m1.inspects * m2.inspects end)
  end

  defp keep_away(monkey_map, rounds, manage?) do
    count = Enum.count(monkey_map)

    Enum.reduce(1..rounds, monkey_map, fn _, monkeys ->
      for monkey_number <- 0..count-1, reduce: monkeys do
        m -> inspect_items(m, monkey_number, manage?)
      end
    end)
  end

  defp inspect_items(monkeys, monkey_number, manage?) do
    monkey = Map.get(monkeys, monkey_number)

    # It will inspect every item
    inspects = Enum.count(monkey.items)

    # Throw the items to other monkeys
    monkeys = throw_items(monkey, monkeys, manage?)

    # Items have been thrown, clear items in inventory and sum total inspects.
    monkey = %{monkey | items: [], inspects: monkey.inspects + inspects}

    Map.put(monkeys, monkey_number, monkey)
  end

  defp throw_items(monkey, monkeys, manage?) do
    {op, val} = monkey.operation
    {worry_func, worry_divisor} = worry_management(monkeys, manage?)

    Enum.reduce(monkey.items, monkeys, fn item, m ->
      val = if val == "old", do: item, else: val
      worry = op.(item, val) |> worry_func.(worry_divisor)
      receiving_number =
        if rem(worry, monkey.test) == 0, do: monkey.pass, else: monkey.fail

      receiving_monkey = Map.get(m, receiving_number)
      receiving_monkey = %{receiving_monkey | items: receiving_monkey.items ++ [worry]}

      Map.put(m, receiving_number, receiving_monkey)
    end)
  end

  defp worry_management(_, false), do: {&div/2, 3}
  defp worry_management(monkeys, true) do
    divisor = Enum.reduce(monkeys, 1, fn {_, %Monkey{test: test}}, product ->
      product * test
    end)

    {&rem/2, divisor}
  end

  defp build_monkeys(monkeys), do: build_monkeys(Map.new(), monkeys)
  defp build_monkeys(map, []), do: map
  defp build_monkeys(map, [monkey | monkeys]) do
    [number, starting_items, operation, test, pass, fail] = monkey

    number = number |> String.at(7) |> stoi()

    monkey = %Monkey{
      operation: format_operation(operation),
      test: format_value(test),
      pass: format_value(pass),
      fail: format_value(fail),
      items: format_starting_items(starting_items)
    }

    map = Map.put(map, number, monkey)

    build_monkeys(map, monkeys)
  end

  defp format_value(str) do
    str |> String.split(" ") |> List.last() |> stoi()
  end

  defp format_operation(op) do
    cond  do
      String.contains?(op, "old * old")->
        {&Kernel.*/2, "old"}

      String.contains?(op, "*") ->
        op
        |> String.split(" * ")
        |> List.last()
        |> then(fn val -> {&Kernel.*/2, stoi(val)} end)

      true ->
        op
        |> String.split(" + ")
        |> List.last()
        |> then(fn val -> {&Kernel.+/2, stoi(val)} end)
    end
  end

  defp format_starting_items(items) do
    items
    |> String.split(": ")
    |> List.last()
    |> String.split(", ")
    |> Enum.map(&stoi/1)
  end
end
