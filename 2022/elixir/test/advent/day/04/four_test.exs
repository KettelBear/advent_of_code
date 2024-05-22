defmodule Advent.Day.FourTest do
  use ExUnit.Case

  alias Advent.Day.Four

  describe "Day 4 code" do
    test "solves part 1" do
      assert Four.part1() == 2
    end

    test "solves part 2" do
      assert Four.part2() == 4
    end
  end
end
