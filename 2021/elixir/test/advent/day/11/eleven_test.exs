defmodule Advent.Day.ElevenTest do
  use ExUnit.Case

  alias Advent.Day.Eleven

  describe "Day 11 code" do
    test "solves part 1" do
      assert Eleven.part1() == 1_656
    end

    test "solves part 2" do
      assert Eleven.part2() == 195
    end
  end
end
