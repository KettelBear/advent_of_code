defmodule Advent.Utility do
  @moduledoc false

  alias Advent.MultiNoMultiError

  defdelegate stoi(str), to: String, as: :to_integer

  @newline ["\n", "\r\n"]
  @double_new ["\n\n", "\r\n\r\n"]

  @typedoc """
  `grid` represents a coordinate system that maps to an `integer`. The
  coordinates will be represented by a touple of `integer`s for the key, and
  the value is an `integer`.
  """
  @type grid :: %{{integer(), integer()} => integer()}

  @typedoc """
  Types that can be returned after parsing the input file.
  """
  @type output :: charlist()
    | grid()
    | integer()
    | String.t()
    | list(charlist())
    | list(integer())
    | list(String.t())
    | list(list(charlist()))
    | list(list(integer()))
    | list(list(String.t()))

  @doc """
  Will take the given `file_path`, read the contents of the file, and return the
  desired output format based on flags provided. It will return the contents of
  the file if no flags are passed in, but broken into a list by lines in the
  file.

  ## Parameters
  - `file_path` - (string) Absolute file path
  - `opts` - (Keyword) possible ways to parse the file

  ## Options
  ### Linebreak Options
  - `double` - (boolean) if `true`, the input will first be broken by a double
    consecutive newline before being split again by single newline characters.
    Also, if `true`, the truthyness of `multi` is ignored. Defaults to `false`.
  - `multi` - (boolean) if `true`, the string input will be broken by a single
    newline character. If `false` (and `double` is `false`) the file contents
    will be returned as a single string read in from the file (unless `integers`
    is set). It will raise `MultiNoMultiError` if set to `false` but the file
    does contain newline characters. Defaults to `true`.

  ### Stringbreak Options
  Not all Strinbreak Options can be paired with one another. Pairings take
  precedence if the pair exists as a viable set of options, otherwise the
  options take precedence alphabetically, unless explictly stated.
  - `charlist` - (boolean) if `true`, the string input will be returned as a
    charlist. Defaults to `false`.
  - `digits` - (boolean) if `true`, the string input will be broken down into
    single characters, then each character converted into an integer type.
    Defaults to `false`.
  - `graphemes` - (boolean) if `true`, the string input will be returned as a
    list of single string characters. Can be paired with option, `integers`.
    Defaults to `false`.
  - `grid` - (boolean) if `true`, the string input will be returned as a map of
    coordinates to integers (ex. {1, 4} => 2). It will take the highest priority
    against all options. Cannot be paired with any other Stringbreak option.
    Defaults to `false`.
  - `integers` - (boolean) if `true`, the string input will be returned as a
    list of integers. Can be paired with options; `graphemes`, `split`. Defaults
    to `false`.
  - `split` - (string) if a string is passed in, the input will attempted to be
    split on the delimiter that was passed in. If `nil` it will not split. Can
    be paired with option, `integers`. Defaults to `nil`.
  """
  @spec parse_input!(file_path :: String.t(), opts :: Keyword.t()) :: output()
  def parse_input!(file_path, opts \\ []) do
    charlist? = Keyword.get(opts, :charlist, false)
    digits? = Keyword.get(opts, :digits, false)
    graphemes? = Keyword.get(opts, :graphemes, false)
    grid? = Keyword.get(opts, :grid, false)
    integers? = Keyword.get(opts, :integers, false)
    splitter = Keyword.get(opts, :split, nil)

    file_contents = file_path |> File.read!() |> break_lines(opts)

    cond do
      grid? -> grid(file_contents)
      digits? -> digits(file_contents)
      integers? and not is_nil(splitter) -> file_contents |> split(splitter) |> numbers()
      charlist? -> chars(file_contents)
      graphemes? -> graphemes(file_contents)
      integers? -> numbers(file_contents)
      not is_nil(splitter) -> split(file_contents, splitter)
      true -> file_contents
    end
  end

  defp break_lines(contents, opts) do
    double? = Keyword.get(opts, :double, false)
    multi? = Keyword.get(opts, :multi, true)

    miss_opt? = not multi? and not double? and String.contains?(contents, @newline)

    cond do
      miss_opt? -> raise MultiNoMultiError
      double? -> handle_double(contents)
      multi? -> handle_multi(contents)
      true -> contents
    end
  end

  defp handle_double(contents) do
    contents
    |> String.split(@double_new, trim: true)
    |> Enum.map(&handle_multi/1)
  end

  defp handle_multi(contents), do: String.split(contents, @newline, trim: true)

  defp chars(contents) when is_list(contents), do: Enum.map(contents, &chars/1)
  defp chars(contents), do: String.to_charlist(contents)

  defp graphemes(contents) when is_list(contents), do: Enum.map(contents, &graphemes/1)
  defp graphemes(contents), do: String.graphemes(contents)

  defp grid(contents) do
    for {line, row} <- contents |> digits() |> Enum.with_index(),
        {height, col} <- Enum.with_index(line), into: %{} do
      {{row, col}, height}
    end
  end

  defp digits(contents) when is_list(contents), do: Enum.map(contents, &digits/1)
  defp digits(contents), do: contents |> graphemes() |> Enum.map(&stoi/1)

  defp numbers(contents) when is_list(contents), do: Enum.map(contents, &numbers/1)
  defp numbers(contents), do: stoi(contents)

  def split(contents, splitter) when is_list(contents), do: Enum.map(contents, &split(&1, splitter))
  def split(contents, splitter), do: String.split(contents, splitter, trim: true)

  @doc """
  Day 8 extra parsing going here to clean up the solutions.
  """
  def parse_day8_input!(file_path) do
    [[instructions] | [nodes]] = parse_input!(file_path, double: true)
    graph = split(nodes, " = ") |> graph_it(%{})

    {String.graphemes(instructions), graph}
  end

  defp graph_it([], graph), do: graph
  defp graph_it([[start, left_right_str] | rest], graph) do
    left_right_tuple = translate_left_right(left_right_str)
    graph_it(rest, Map.put(graph, start, left_right_tuple))
  end

  defp translate_left_right(str) do
    [left, right] = split(str, ", ")

    {String.replace(left, "(", ""), String.replace(right, ")", "")}
  end
end

defmodule Advent.MultiNoMultiError do
  @moduledoc false

  defexception message: "Multiple lines in file, multi flag unused."
end
