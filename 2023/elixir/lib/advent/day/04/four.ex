defmodule Advent.Day.Four do
  @moduledoc false

  import Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: [": ", " | "])
    |> Enum.map(&split(&1, " "))
    |> tally_cards()
    |> Enum.sum()
  end

  defp tally_cards([]), do: []
  defp tally_cards([[_card_num, winning_nums, my_nums] | rest]) do
    winners = MapSet.new(winning_nums)

    [points(my_nums, winners) | tally_cards(rest)]
  end

  defp points(nums, winners) do
    case num_of_wins(nums, winners) do
      0 -> 0
      power -> 2 ** (power - 1)
    end
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> parse_input!(split: [": ", " | "])
    |> Enum.map(&split(&1, " "))
    |> play_cards(%{})
    |> Map.values()
    |> Enum.sum()
  end

  defp play_cards([], copies), do: copies
  defp play_cards([[[_, game_num], winners, my_nums] | rest], copies) do
    winners = MapSet.new(winners)

    # Add in the original card.
    copies = Map.update(copies, game_num, 1, &(&1 + 1))

    case num_of_wins(my_nums, winners) do
      0 -> 
        play_cards(rest, copies)

      wins ->
        game_int = stoi(game_num)

        copies =
          (game_int + 1)..(game_int + wins)
          |> Enum.reduce(copies, fn card_num, acc ->
            copies_won = Map.get(copies, game_num)
            Map.update(acc, "#{card_num}", copies_won, &(&1 + copies_won))
          end)

        play_cards(rest, copies)
    end
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp num_of_wins(game_numbers, winning_numbers) do
    Enum.count(game_numbers, fn n -> MapSet.member?(winning_numbers, n) end)
  end
end
