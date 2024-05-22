defmodule Advent.Day.SixTest do
  use ExUnit.Case

  alias Advent.Day.Six

  describe "Day 6 code" do
    test "solves part 1" do
      assert Six.part1() == 11
    end

    test "solves part 2" do
      assert Six.part2() == 26
    end
  end
end
