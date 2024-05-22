defmodule Advent.Day.OneTest do
  use ExUnit.Case

  alias Advent.Day.One

  describe "Day 1 code" do
    test "solves part 1" do
      assert One.part1() == 24_000
    end

    test "solves part 2" do
      assert One.part2() == 45_000
    end
  end
end
