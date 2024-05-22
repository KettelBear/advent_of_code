defmodule Advent.Day.TwelveTest do
  use ExUnit.Case

  alias Advent.Day.Twelve

  describe "Day 12 code" do
    test "solves part 1" do
      assert Twelve.part1() == 31
    end

    test "solves part 2" do
      assert Twelve.part2() == 29
    end
  end
end
