defmodule Advent.Day.FifteenTest do
  use ExUnit.Case

  alias Advent.Day.Fifteen

  describe "Day 15 code" do
    test "solves part 1" do
      assert Fifteen.part1() == 40
    end

    test "solves part 2" do
      assert Fifteen.part2() == 315
    end
  end
end
