defmodule Advent.Day.EightTest do
  use ExUnit.Case

  alias Advent.Day.Eight

  describe "Day 8 code" do
    test "solves part 1" do
      assert Eight.part1() == 26
    end

    test "solves part 2" do
      assert Eight.part2() == 61_229
    end
  end
end
