defmodule Mix.Tasks.Gen.Day do
  @moduledoc """
  An elixir script to generate all the template code for the Advent of Code
  day that will be worked on.
  """

  @shortdoc "Generates Advent of Code Day"

  use Mix.Task

  @impl Mix.Task
  def run([day]) do
    day_int = String.to_integer(day)

    if day_int < 1 or day_int > 25, do: raise "Failed to pass in proper Advent Day."

    day_int |> create_folders() |> create_files(day_int)
  end

  @days_folder "lib/advent/day"
  @test_folder "test/advent/day"

  @day_names %{
    1 => "One",
    2 => "Two",
    3 => "Three",
    4 => "Four",
    5 => "Five",
    6 => "Six",
    7 => "Seven",
    8 => "Eight",
    9 => "Nine",
    10 => "Ten",
    11 => "Eleven",
    12 => "Twelve",
    13 => "Thirteen",
    14 => "Fourteen",
    15 => "Fifteen",
    16 => "Sixteen",
    17 => "Seventeen",
    18 => "Eighteen",
    19 => "Nineteen",
    20 => "Twenty",
    21 => "TwentyOne",
    22 => "TwentyTwo",
    23 => "TwentyThree",
    24 => "TwentyFour",
    25 => "TwentyFive",
  }

  @day_code """
  defmodule Advent.Day.{{name}} do
    @moduledoc false

    import Advent.Utility

    @doc false
    def part1 do
      "\#{__DIR__}/input.test"
      |> parse_input!()
    end

    @doc false
    def part2 do
      "\#{__DIR__}/input.test"
      |> parse_input!()
    end

    ##############################
    #                            #
    #     Used By Both Parts     #
    #                            #
    ##############################
  end
  """

  @test_code """
  defmodule Advent.Day.{{name}}Test do
    use ExUnit.Case

    alias Advent.Day.{{name}}

    describe "Day {{number}} code" do
      test "solves part 1" do
        assert {{name}}.part1() == -1
      end

      test "solves part 2" do
        assert {{name}}.part2() == -1
      end
    end
  end
  """

  defp create_folders(day) do
    folder_name = if day > 9, do: "#{day}", else: "0#{day}"

    code_path = create_folder(@days_folder, folder_name)
    test_path = create_folder(@test_folder, folder_name)

    {code_path, test_path}
  end

  defp create_folder(prefix, folder_name) do
    code_path = "#{prefix}/#{folder_name}"
    File.mkdir!(code_path)
    code_path
  end

  defp create_files({code_path, test_path}, day) do
    day_name = Map.get(@day_names, day)

    code_path
    |> create_code_file(day_name)
    |> create_input_file()

    create_test_file(test_path, day_name, day)
  end

  defp create_code_file(path, day_name) do
    contents = String.replace(@day_code, "{{name}}", day_name)

    file = "#{path}/#{Macro.underscore(day_name)}.ex"

    File.write!(file, contents)

    path
  end

  defp create_input_file(path) do
    File.write!("#{path}/input.test", "Paste Input Here")
  end

  defp create_test_file(path, day_name, day) do
    contents = String.replace(@test_code, ["{{name}}", "{{number}}"], fn
      "{{name}}" -> day_name
      "{{number}}" -> "#{day}"
    end)

    file = "#{path}/#{Macro.underscore(day_name)}_test.exs"

    File.write!(file, contents)
  end
end
