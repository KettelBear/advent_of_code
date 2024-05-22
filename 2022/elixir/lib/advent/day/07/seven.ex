defmodule Advent.Day.Seven do
  @moduledoc false

  alias Advent.Day.Seven.Directory
  alias Advent.Utility

  defmodule Directory do
    @type t :: %__MODULE__{
      parent: Directory.t() | nil,
      name: String.t(),
      size: integer(),
      dirs: list(String.t()),
      files: list({String.t(), integer()})
    }
    @enforce_keys [:name]
    defstruct [:parent, name: "", size: 0, dirs: [], files: []]
  end

  @disk_space 70_000_000
  @space_for_update 30_000_000
  @too_big 100_000

  @doc false
  def part1 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(split: " ")
    |> build_dir_list()
    |> sum_small_dirs()
  end

  defp sum_small_dirs(dir_list) do
    Enum.reduce(dir_list, 0, fn {_, %{size: size}}, acc ->
      if size > @too_big do
        acc
      else
        acc + size
      end
    end)
  end

  @doc false
  def part2 do
    "#{__DIR__}/input.test"
    |> Utility.parse_input!(split: " ")
    |> build_dir_list()
    |> smallest_delete()
  end

  defp smallest_delete(dir_list) do
    need_to_free = Map.get(dir_list, "/").size - (@disk_space - @space_for_update)

    Enum.reduce(dir_list, @disk_space, fn {_, %{size: size}}, smallest ->
      if size - need_to_free > 0 and size < smallest, do: size, else: smallest
    end)
  end

  ##############################
  #                            #
  #     Used By Both Parts     #
  #                            #
  ##############################

  defp build_dir_list(stdout), do: build_dir_list(%{}, stdout, nil)
  defp build_dir_list(dir_list, [], _) do
    root = Map.get(dir_list, "/")
    size = Enum.reduce(root.dirs, 0, &(&2 + Map.get(dir_list, &1).size))
    Map.put(dir_list, "/", %{root | size: root.size + size})
  end
  defp build_dir_list(dir_list, [stdout_line | stdout], working_dir) do
    case stdout_line do
      ["$", "cd", "/"] ->
        curr_dir = %Directory{name: "/"}
        dir_list
        |> Map.put("/", curr_dir)
        |> build_dir_list(stdout, curr_dir)

      ["$", "cd", ".."] ->
        size = Enum.reduce(working_dir.dirs, 0, &(&2 + Map.get(dir_list, &1).size))
        working_dir = %{working_dir | size: working_dir.size + size}
        dir_list = Map.put(dir_list, working_dir.name, working_dir)
        curr_dir = Map.get(dir_list, working_dir.parent)
        build_dir_list(dir_list, stdout, curr_dir)

      ["$", "cd", dir] ->
        full_path = "#{working_dir.name}/#{dir}"
        curr_dir = %Directory{name: full_path, parent: working_dir.name}
        dir_list
        |> Map.put(full_path, curr_dir)
        |> build_dir_list(stdout, curr_dir)

      ["$", "ls"] ->
        build_dir_list(dir_list, stdout, working_dir)

      ["dir", dir_name] ->
        full_path = "#{working_dir.name}/#{dir_name}"
        updated = [full_path | working_dir.dirs]
        working_dir = %{working_dir | dirs: updated}

        dir_list
        |> Map.put(working_dir.name, working_dir)
        |> build_dir_list(stdout, working_dir)

      [file_size, file_name] ->
        size = String.to_integer(file_size)
        updated = [{file_name, size} | working_dir.files]
        new_size = working_dir.size + size

        working_dir = %{working_dir | files: updated, size: new_size}

        dir_list
        |> Map.put(working_dir.name, working_dir)
        |> build_dir_list(stdout, working_dir)
    end
  end
end
