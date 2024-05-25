defmodule Advent.Day.SevenTest do
  use ExUnit.Case

  alias Advent.Day.Seven

  describe "Day 7 code" do
    test "solves part 1" do
      assert Seven.part1() == 37
    end

    test "solves part 2" do
      assert Seven.part2() == 168
    end
  end
end
