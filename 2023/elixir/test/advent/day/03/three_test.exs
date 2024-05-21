defmodule Advent.Day.ThreeTest do
  use ExUnit.Case

  alias Advent.Day.Three

  describe "Day 3 code" do
    test "solves part 1" do
      assert Three.part1() == 4_361
    end

    test "solves part 2" do
      assert Three.part2() == 467_835
    end
  end
end
