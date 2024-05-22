defmodule Advent.Day.TwoTest do
  use ExUnit.Case

  alias Advent.Day.Two

  describe "Day 2 code" do
    test "solves part 1" do
      assert Two.part1() == 15
    end

    test "solves part 2" do
      assert Two.part2() == 12
    end
  end
end
