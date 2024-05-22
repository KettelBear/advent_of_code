defmodule Advent.Utility do
  @moduledoc false

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
    Also, if `true`, the truthyness of `multi` is ignored. Defaults to `false`
  - `multi` - (boolean) if `true`, the string input will be broken by a single
    newline character. If `false` (and `double` is `false`) the file contents
    will be returned as a single string read in from the file (unless `integers`
    is set). Defaults to `true`

  ### Stringbreak Options
  Not all Strinbreak Options can be paired with one another. Pairings take
  precedence if the pair exists as a viable set of options, otherwise the
  options take precedence alphabetically, unless explictly stated.
  - `charlist` - (boolean) if `true`, the string input will be returned as a
    charlist. Defaults to `false`
  - `graphemes` - (boolean) if `true`, the string input will be returned as a
    list of single string characters. Can be paired with option, `integers`.
    Defaults to `false`
  - `grid` - (boolean) if `true`, the string input will be returned as a map of
    coordinates to integers (ex. {1, 4} => 2). It will take the highest priority
    against all options. Cannot be paired with any other Stringbreak option.
    Defaults to `false`
  - `integers` - (boolean) if `true`, the string input will be returned as a
    list of integers. Can be paired with options; `graphemes`, `split`. Defaults
    to `false`
  - `split` - (string) if a string is passed in, the input will attempted to be
    split on the delimiter that was passed in. If `nil` it will not split. Can
    be paired with option, `integers`. Defaults to `nil`
  """
  @spec parse_input!(file_path :: String.t(), opts :: Keyword.t()) :: output()
  def parse_input!(file_path, opts \\ []) do
    charlist? = Keyword.get(opts, :charlist, false)
    graphemes? = Keyword.get(opts, :graphemes, false)
    grid? = Keyword.get(opts, :grid, false)
    integers? = Keyword.get(opts, :integers, false)
    splitter = Keyword.get(opts, :split, nil)

    file_contents = File.read!(file_path)

    file_contents = break_lines(file_contents, opts)

    cond do
      grid? -> grid(file_contents)
      graphemes? and integers? -> digits(file_contents)
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
      miss_opt? -> raise Advent.MultiNoMultiError
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

  defp split(contents, splitter) when is_list(contents), do: Enum.map(contents, &split(&1, splitter))
  defp split(contents, splitter), do: String.split(contents, splitter, trim: true)

  @doc """
  For 2022, day 5 required a special sort of parsing. So, it has been added to
  the utility file to keep the solutions themselves concise. Reading the parsing
  functions should show how convoluted this parsing is.
  """
  def parse_day_five(file_path) do
    file_path
    |> File.read!()
    |> String.split(@double_new)
    |> then(fn input -> input |> parse_stacks() |> parse_instructions() end)
  end

  defp parse_stacks([stacks, instructions]) do
    stack_map =
      stacks
      |> String.split(@newline, trim: false)
      |> graphemes()
      |> Enum.map(&Enum.with_index/1)
      |> Enum.reverse()
      |> tl()
      |> Enum.reduce(%{}, fn row, map ->
        Enum.reduce(row, map, fn
          {" ", _}, m -> m
          {"[", _}, m -> m
          {"]", _}, m -> m
          {char, idx}, m ->
            Map.update(m, calc_idx(idx), [char], fn list -> [char | list] end)
        end)
      end)

    {stack_map, instructions}
  end

  defp calc_idx(n), do: n |> Kernel.-(1) |> Kernel.div(4) |> Kernel.+(1)

  defp parse_instructions({stack_map, instructions}) do
    parsed_instr =
      instructions
      |> String.split(@newline, trim: true)
      |> Enum.map(&String.split(&1, " ", trim: true))
      |> Enum.map(fn ["move", num_boxes, "from", start, "to", dest] ->
        [stoi(num_boxes), stoi(start), stoi(dest)]
      end)

    {stack_map, parsed_instr}
  end
end

defmodule Advent.MultiNoMultiError do
  @moduledoc false

  defexception message: "Multiple lines in file, multi flag unused."
end
