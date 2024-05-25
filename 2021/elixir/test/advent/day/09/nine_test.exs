defmodule Advent.Day.NineTest do
  use ExUnit.Case

  alias Advent.Day.Nine

  describe "Day 9 code" do
    test "solves part 1" do
      assert Nine.part1() == 15
    end

    test "solves part 2" do
      assert Nine.part2() == 1_134
    end
  end
end
