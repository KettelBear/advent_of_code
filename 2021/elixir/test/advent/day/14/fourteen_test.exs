defmodule Advent.Day.FourteenTest do
  use ExUnit.Case

  alias Advent.Day.Fourteen

  describe "Day 14 code" do
    test "solves part 1" do
      assert Fourteen.part1() == 1_588
    end

    test "solves part 2" do
      assert Fourteen.part2() == 2_188_189_693_529
    end
  end
end
