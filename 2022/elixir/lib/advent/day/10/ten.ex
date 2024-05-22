defmodule Advent.Day.Ten do
  @moduledoc false

  alias Advent.Utility

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(split: " ")
    |> cycle()
    |> Enum.sum()
  end

  defp cycle(instr), do: cycle(1, 0, [], instr)
  defp cycle(_, c, important, _) when c > 220, do: important
  defp cycle(x, c, important, [i | instr]) do
    {x, c, important} = handle_instruction(x, c, important, i)

     cycle(x, c, important, instr)
  end

  defp handle_instruction(x, c, important, ["noop"]) do
    c = c + 1
    important = calc(x, c, important)
    {x, c, important}
  end
  defp handle_instruction(x, c, important, ["addx", n]) do
    c = c + 1
    important = calc(x, c, important)
    c = c + 1
    important = calc(x, c, important)
    {x + String.to_integer(n), c, important}
  end

  defp calc(x, 20, important), do: [x * 20 | important]
  defp calc(x, 60, important), do: [x * 60 | important]
  defp calc(x, 100, important), do: [x * 100 | important]
  defp calc(x, 140, important), do: [x * 140 | important]
  defp calc(x, 180, important), do: [x * 180 | important]
  defp calc(x, 220, important), do: [x * 220 | important]
  defp calc(_, _, important), do: important

  @doc """
  This challenge is based on a visual that is printed out to the CLI. The
  private function `print_crt/2` has a boolean set to false to prevent output
  when running the entire test suite. Set to true to see the output.

  Because of this, I am just returning true at the end of the function to
  have something to assert on, rather than asserting on a list of lists and
  its format.
  """
  def part2 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(split: " ")
    |> draw()

    true
  end

  defp generate_crt() do
    for n <- 0..239, reduce: %{} do
      m -> Map.put(m, n, " ")
    end
  end

  defp draw(instr), do: draw([0, 1, 2], 0, generate_crt(), instr)
  # To actually print, set the `false` to `true` here.
  defp draw(_, _, crt, []), do: print_crt(crt, false)
  defp draw(sprite, c, crt, [i | instr]) do
    {sprite, c, crt} = handle_instr(sprite, c, crt, i)

    draw(sprite, c, crt, instr)
  end

  defp handle_instr(sprite, c, crt, ["noop"]) do
    crt = update_crt(sprite, c, crt)
    c = c + 1
    {sprite, c, crt}
  end
  defp handle_instr(sprite, c, crt, ["addx", n]) do
    crt = update_crt(sprite, c, crt)
    c = c + 1
    crt = update_crt(sprite, c, crt)
    c = c + 1
    n = String.to_integer(n)
    {Enum.map(sprite, &(&1 + n)), c, crt}
  end

  defp update_crt(sprite, c, crt) do
    if rem(c, 40) in sprite do
      Map.put(crt, c, "$")
    else
      crt
    end
  end

  defp print_crt(crt, print?) do
    if print? do
      IO.write("\n")
      for i <- 0..239 do
        IO.write(Map.get(crt, i))
        if rem(i+1, 40) == 0, do: IO.write("\n")
      end
    end
  end
end
