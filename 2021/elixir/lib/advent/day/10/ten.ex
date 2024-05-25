defmodule Advent.Day.Ten do
  @moduledoc false

  @lookup %{"(" => ")", "[" => "]", "{" => "}", "<" => ">"}
  @openers ["(", "[", "{", "<"]
  @p1_points %{")" => 3, "]" => 57, "}" => 1_197, ">" => 25_137}
  @p2_points %{")" => 1, "]" => 2, "}" => 3, ">" => 4}

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(graphemes: true)
    |> collect_bad_closers()
    |> sum_syntax_error()
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(graphemes: true)
    |> collect_line_finishers()
    |> auto_complete_scores()
    |> Enum.sort()
    |> get_median_score()
  end

  defp collect_line_finishers(lines) do
    Enum.reduce(lines, [], fn line, acc ->
      line
      |> Enum.reduce_while({[], false}, fn char, {stack, _bad_char} ->
        cond do
          char in @openers -> {:cont, {[@lookup[char] | stack], false}}
          char == hd(stack) -> {:cont, {tl(stack), false}}
          true -> {:halt, {stack, true}}
        end
      end)
      |> then(fn {stack, bad?} -> if not bad?, do: [stack | acc], else: acc end)
    end)
  end

  defp auto_complete_scores(lines), do: auto_complete_scores([], lines)
  defp auto_complete_scores(scores, []), do: scores
  defp auto_complete_scores(scores, [line | lines]) do
    line_score = Enum.reduce(line, 0, fn char, acc -> acc * 5 + @p2_points[char] end)

    auto_complete_scores([line_score | scores], lines)
  end

  defp get_median_score(scores) do
    Enum.at(scores, length(scores) |> div(2))
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp collect_bad_closers(lines) do
    Enum.reduce(lines, %{")" => 0, "]" => 0, "}" => 0, ">" => 0}, fn line, acc ->
      line
      |> Enum.reduce_while({[], ""}, fn char, {stack, _bad_char} ->
        cond do
          char in @openers -> {:cont, {[@lookup[char] | stack], ""}}
          char == hd(stack) -> {:cont, {tl(stack), ""}}
          true -> {:halt, {stack, char}}
        end
      end)
      |> then(fn {_stack, bad_char} -> Map.update(acc, bad_char, 1, &(&1 + 1)) end)
    end)
    |> Map.delete("")
  end

  defp sum_syntax_error(bad_occurrences) do
    Enum.reduce(bad_occurrences, 0, fn {char, occurrences}, sum ->
      sum + occurrences * @p1_points[char]
    end)
  end
end
