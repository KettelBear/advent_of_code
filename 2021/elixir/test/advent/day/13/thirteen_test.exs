defmodule Advent.Day.ThirteenTest do
  use ExUnit.Case

  alias Advent.Day.Thirteen

  describe "Day 13 code" do
    test "solves part 1" do
      assert Thirteen.part1() == 17
    end

    test "solves part 2" do
      assert Thirteen.part2() |> Enum.all?(&(&1 == :ok))
    end
  end
end
