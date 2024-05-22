defmodule Advent.Day.SevenTest do
  use ExUnit.Case

  alias Advent.Day.Seven

  describe "Day 7 code" do
    test "solves part 1" do
      assert Seven.part1() == 95_437
    end

    test "solves part 2" do
      assert Seven.part2() == 24_933_642
    end
  end
end
