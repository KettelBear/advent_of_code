defmodule Advent.Day.NineTest do
  use ExUnit.Case

  alias Advent.Day.Nine

  describe "Day 9 code" do
    test "solves part 1" do
      assert Nine.part1() == 13
    end

    test "solves part 2" do
      assert Nine.part2() == 36
    end
  end
end
