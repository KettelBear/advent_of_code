defmodule Advent.Day.Four do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    [[called_nums_csv] | janky_boards] = parse_input!("#{__DIR__}/input.test", double: true)

    called_numbers = parse_numbers(called_nums_csv)
    clean_boards = get_clean_boards(janky_boards)

    {boards, remaining_numbers} = draw_first_four(clean_boards, called_numbers)

    {winning_board, last_called} = find_first_winner(boards, remaining_numbers)

    sum_winning_board(winning_board) * last_called
  end

  @doc false
  def part2 do
    [[called_nums_csv] | janky_bords] = parse_input!("#{__DIR__}/input.test", double: true)

    called_numbers = parse_numbers(called_nums_csv)
    clean_boards = get_clean_boards(janky_bords)

    {boards, remaining_numbers} = draw_first_four(clean_boards, called_numbers)

    {winning_board, last_called} = find_last_winner(boards, remaining_numbers)

    sum_winning_board(winning_board) * last_called
  end

  def find_last_winner(_boards, []), do: :error
  def find_last_winner([last_board], numbers) do
    # Even though there is only one board left, it might not win for multiple called numbers
    find_first_winner([last_board], numbers)
  end
  def find_last_winner(boards, [next_call | rest]) do
    next_call
    |> call_number(boards)
    |> Enum.reject(&winner?/1)
    |> find_last_winner(rest)
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  def find_first_winner(boards, [call | remaining]) do
    boards = call_number(call, boards)

    case Enum.find(boards, &winner?/1) do
      nil -> find_first_winner(boards, remaining)
      winner -> {winner, call}
    end
  end

  defp winner?(boards) do
    columns = boards |> List.zip() |> Enum.map(&Tuple.to_list/1)

    Enum.any?(boards, &winning_row?/1) or Enum.any?(columns, &winning_row?/1)
  end

  defp winning_row?(row), do: Enum.all?(row, fn {_value, called?} -> called? end)

  defp sum_winning_board(board) do
    board
    |> List.flatten()
    |> Enum.reject(fn {_value, called?} -> called? end)
    |> Enum.reduce(0, fn {value, _called?}, sum -> sum + value end)
  end

  defp draw_first_four(boards, called) do
    {first_four, remaining} = Enum.split(called, 4)

    {Enum.reduce(first_four, boards, &call_number/2), remaining}
  end

  def call_number(number, boards) do
    for board <- boards do
      for row <- board do
        for {value, called} <- row do
          if value == number, do: {value, true}, else: {value, called}
        end
      end
    end
  end

  defp get_clean_boards(janky_boards), do: Enum.map(janky_boards, &set_rows/1)

  defp set_rows(board) do
    Enum.map(board, fn row -> row |> space_split() |> Enum.map(&{stoi(&1), false}) end)
  end

  defp space_split(string), do: String.split(string, " ", trim: true)

  defp parse_numbers(numbers_csv) do
    numbers_csv |> String.split(",", trim: true) |> Enum.map(&stoi/1)
  end
end
