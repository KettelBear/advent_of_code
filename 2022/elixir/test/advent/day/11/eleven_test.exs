defmodule Advent.Day.ElevenTest do
  use ExUnit.Case

  alias Advent.Day.Eleven

  describe "Day 11 code" do
    test "solves part 1" do
      assert Eleven.part1() == 10_605
    end

    test "solves part 2" do
      assert Eleven.part2() == 2_713_310_158
    end
  end
end
