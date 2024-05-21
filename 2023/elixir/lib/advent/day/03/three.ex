defmodule Advent.Day.Three do
  @moduledoc false

  import Advent.Utility

  @symbols ~c($*=-#@&%/+)

  @doc false
  def part1 do
    input = parse_input!("#{__DIR__}/input.test", charlist: true)

    numbers = find_numbers(input)

    grid = gridify(input)

    Enum.reduce(numbers, 0, fn {{x, y}, digits}, sum ->
      outline = get_outline(x, y, length(digits))

      if Enum.any?(outline, &symbol?(&1, grid)) do
        sum + List.to_integer(digits)
      else
        sum
      end
    end)
  end

  defp symbol?(point, grid), do: Map.get(grid, point) in @symbols

  @doc false
  def part2 do
    input = parse_input!("#{__DIR__}/input.test", charlist: true)

    numbers = find_numbers(input) |> generate_pointers()

    gears = gridify(input) |> Enum.filter(fn {_, c} -> c == ?* end)

    Enum.reduce(gears, 0, fn {{x, y}, _}, sum ->
      outline = get_outline(x, y, 1)

      case gear_nums(outline, numbers) do
        [one, two] ->
          one = numbers |> Map.get(one) |> List.to_integer()
          two = numbers |> Map.get(two) |> List.to_integer()
          sum + one * two

        _ ->
          sum
      end
    end)
  end

  # For each position that the number is, it will all point to the starting
  # digit. An example of what 522 would look like, where the 5 is in position
  # {2, 2}:
  # %{{2, 2} => 5, {2, 3} => {2, 2}, {2, 4} => {2, 2}}
  defp generate_pointers(nums) do
    Enum.reduce(nums, nums, fn 
      # One digit number doesn't need pointers.
      {_point, [_only_digit]}, acc ->
        acc

      {{x, y}, num}, acc ->
        Enum.reduce(y+1..(y+(length(num)-1)), acc, fn dy, a ->
          Map.put(a, {x, dy}, {x, y})
        end)
    end)
  end

  defp gear_nums(outline, numbers) do
    Enum.reduce(outline, MapSet.new(), fn point, acc ->
      case Map.get(numbers, point) do
        nil -> acc
        val when is_tuple(val) -> MapSet.put(acc, val)
        _ -> MapSet.put(acc, point)
      end
    end)
    |> MapSet.to_list()
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp find_numbers(input), do: input |> Enum.with_index() |> find_numbers(%{})
  defp find_numbers([], acc), do: acc
  defp find_numbers([{row, x} | rest], acc) do
    acc =
      row
      |> Enum.with_index()
      |> nums_for_row([], x, acc)

    find_numbers(rest, acc)
  end

  defp nums_for_row([{char, y}], digit_list, x, acc) do
    cond do
      char in ?0..?9 ->
        digit_list = [char | digit_list]
        Map.put(acc, {x, y - (length(digit_list) - 1)}, Enum.reverse(digit_list))

      digit_list != [] ->
        Map.put(acc, {x, y - length(digit_list)}, Enum.reverse(digit_list))

      true ->
        acc
    end
  end
  defp nums_for_row([{char, _} | rest], [], x, acc) when char in ?1..?9 do
    nums_for_row(rest, [char], x, acc)
  end
  defp nums_for_row([{char, _} | rest], digit_list, x, acc) when char in ?0..?9 do
    nums_for_row(rest, [char | digit_list], x, acc)
  end
  defp nums_for_row([_ | rest], [], x, acc) do
    nums_for_row(rest, [], x, acc)
  end
  defp nums_for_row([{_, y} | rest], digit_list, x, acc) do
    acc = Map.put(acc, {x, y - length(digit_list)}, Enum.reverse(digit_list))
    nums_for_row(rest, [], x, acc)
  end

  defp gridify(loloc) do
    for {row, x} <- Enum.with_index(loloc), {char, y} <- Enum.with_index(row), into: %{} do
      {{x, y}, char}
    end
  end

  defp get_outline(x, y, len) do
    points = Enum.reduce(y-1..y+len, [], &([{x-1, &1} | &2]))
    points = [{x, y-1}, {x, y+len} | points]
    Enum.reduce(y-1..y+len, points, &([{x+1, &1} | &2]))
  end
end
