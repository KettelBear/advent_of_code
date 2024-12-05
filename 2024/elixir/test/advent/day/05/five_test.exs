defmodule Advent.Day.FiveTest do
  use ExUnit.Case

  alias Advent.Day.Five

  describe "Day 5 code" do
    test "solves part 1" do
      assert Five.part1() == 143
    end

    test "solves part 2" do
      assert Five.part2() == 123
    end
  end
end
