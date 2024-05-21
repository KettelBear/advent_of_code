defmodule Advent.UtilityTest do
  use ExUnit.Case, async: true

  alias Advent.MultiNoMultiError
  alias Advent.Utility

  describe "parse_input!" do
    test "raises when file does not exist" do
      try do
        Utility.parse_input!("file_does_not_exist.txt")
        flunk("An exception should have been raised.")
      rescue
        File.Error -> :ok
        _ -> flunk("Caught the wrong error.")
      end
    end

    test "returns a grid of integers" do
      actual = Utility.parse_input!( "test/data/multi_grapheme_integers.txt", digits: true)

      assert(actual == [[1, 2, 3], [4, 5, 6]])
    end

    test "returns a list of lists containing characters" do
      actual = Utility.parse_input!("test/data/multi_charlist.txt", charlist: true)

      assert(actual == ['abc', 'def'])
    end

    test "returns a list of lists containing graphemes" do
      actual = Utility.parse_input!("test/data/multi_graphemes.txt", graphemes: true)

      assert(actual == [["a", "b", "c"], ["d", "e", "f"]])
    end

    test "returns a list of integers" do
      actual = Utility.parse_input!("test/data/multi_integer.txt", integers: true)

      assert(actual == [123, 456])
    end

    test "returns a list of strings split by special characters" do
      actual = Utility.parse_input!("test/data/multi_splitter.txt", split: " -> ")

      assert(actual == [["A", "B"], ["C", "D"]])
    end

    test "returns a list of strings for each line" do
      actual = Utility.parse_input!("test/data/multi.txt")

      assert(actual == ["line one", "line two", "line three"])
    end

    test "returns a list of characters" do
      actual = Utility.parse_input!("test/data/charlist.txt", multi: false, charlist: true)

      assert(actual == 'abcdef')
    end

    test "returns a list of graphemes" do
      actual = Utility.parse_input!("test/data/graphemes.txt", multi: false, graphemes: true)

      assert(actual == ["a", "b", "c", "d", "e", "f"])
    end

    test "returns an integer" do
      actual = Utility.parse_input!("test/data/integer.txt", multi: false, integers: true)

      assert(actual == 123456)
    end

    test "returns a string split by the special characters" do
      actual = Utility.parse_input!("test/data/splitter.txt", multi: false, split: ".-^-.")

      assert(actual == ["A", "B", "C", "D"])
    end

    test "returns the contents of the file as a string" do
      actual = Utility.parse_input!("test/data/no_flags.txt", multi: false)

      assert(actual == "abcdefghijkl")
    end

    test "raises ArgumentError when line contains invalid integers" do
      try do
        Utility.parse_input!("test/data/invalid_integers.txt", integers: true)
        flunk("An exception should have been raised.")
      rescue
        ArgumentError -> :ok
        _ -> flunk("Caught the wrong error.")
      end
    end

    test "raises if the string contains newline characters, and multi flag was passed in false" do
      try do
        Utility.parse_input!("test/data/no_flags_with_multi.txt", multi: false)
        flunk("An exception should have been raised.")
      rescue
        MultiNoMultiError -> :ok
        _ -> flunk("Caught the wrong error.")
      end
    end
  end
end
