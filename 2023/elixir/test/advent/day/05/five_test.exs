defmodule Advent.Day.FiveTest do
  use ExUnit.Case

  alias Advent.Day.Five

  describe "Day 5 code" do
    test "solves part 1" do
      assert Five.part1() == 35
    end

    test "solves part 2" do
      assert Five.part2() == 46
    end
  end
end
