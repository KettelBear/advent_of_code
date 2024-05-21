defmodule Advent.Day.SixTest do
  use ExUnit.Case

  alias Advent.Day.Six

  describe "Day 6 code" do
    test "solves part 1" do
      assert Six.part1() == 288
    end

    test "solves part 2" do
      assert Six.part2() == 71_503
    end
  end
end
