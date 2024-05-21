defmodule Advent.Day.OneTest do
  use ExUnit.Case

  alias Advent.Day.One

  describe "Day 1 code" do
    test "solves part 1" do
      assert One.part1() == 142
    end

    test "solves part 2" do
      assert One.part2() == 281
    end
  end
end
