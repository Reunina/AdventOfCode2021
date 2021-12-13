defmodule Day13Test do
  use ExUnit.Case, async: true
  alias FileReader
  doctest Day13

  alias Day13, as: Day

  @test_input "inputs/tests/day_13.txt"
  @real_input "inputs/day_13.txt"

  test "day 13 part 1" do
    assert 17 =
             @test_input
             |> extract_data
             |> Day.part_01()
             |> Enum.count()

    assert 847 =
             @real_input
             |> extract_data
             |> Day.part_01()
             |> Enum.count()
  end

  test "day 13 part 2" do
    assert [
             [5, 26],
             [4, 23],
             [0, 37],
             [5, 27],
             [4, 3],
             [1, 25],
             [3, 25],
             [5, 2],
             [3, 11],
             [0, 7],
             [0, 32],
             [2, 37],
             [3, 5],
             [1, 20],
             [0, 1],
             [2, 18],
             [2, 27],
             [1, 3],
             [1, 13],
             [3, 17],
             [2, 15],
             [5, 33],
             [0, 15],
             [1, 0],
             [5, 35],
             [2, 0],
             [2, 36],
             [1, 35],
             [5, 6],
             [1, 33],
             [1, 18],
             [0, 0],
             [2, 20],
             [0, 21],
             [3, 32],
             [5, 18],
             [5, 21],
             [5, 7],
             [4, 20],
             [0, 27],
             [2, 25],
             [0, 26],
             [0, 25],
             [2, 35],
             [0, 6],
             [4, 15],
             [0, 2],
             [3, 38],
             [3, 20],
             [4, 10],
             [3, 15],
             [1, 8],
             [5, 1],
             [5, 25],
             [0, 10],
             [5, 37],
             [1, 38],
             [0, 31],
             [5, 36],
             [5, 11],
             [0, 22],
             [5, 10],
             [5, 0],
             [5, 28],
             [5, 30],
             [5, 22],
             [3, 16],
             [3, 3],
             [0, 11],
             [4, 35],
             [3, 0],
             [4, 25],
             [4, 17],
             [0, 35],
             [2, 12],
             [0, 12],
             [1, 23],
             [3, 30],
             [0, 16],
             [5, 15],
             [4, 5],
             [2, 5],
             [0, 36],
             [1, 5],
             [0, 28],
             [3, 35],
             [2, 2],
             [4, 38],
             [3, 33],
             [0, 13],
             [0, 17],
             [2, 1],
             [5, 12],
             [2, 33],
             [5, 13],
             [4, 33],
             [1, 15],
             [1, 30],
             [2, 30],
             [4, 8],
             [2, 26],
             [4, 30],
             [3, 31],
             [4, 0]
           ] =
             @real_input
             |> extract_data
             |> Day.part_02()
             #|> Day.pretty_print("day 13, part 2")
  end

  defp extract_data(filename) do
    {coordinates, fold_instructions} =
      filename
      |> FileReader.read_file()
      |> Enum.to_list()
      |> Enum.reject(fn x -> x == "" end)
      |> Enum.split_while(fn x -> not String.starts_with?(x, "fold ") end)

    {
      coordinates |> Enum.map(&format_coordinates/1),
      fold_instructions |> Enum.map(&format_fold_instructions/1)
    }
  end

  defp format_fold_instructions(instructions) do
    [_, _, x_or_y, val] = instructions |> String.split([" ", "="], trim: true)
    {x_or_y, String.to_integer(val)}
  end

  defp format_coordinates(coordinates) do
    coordinates
    |> String.split(",", trim: true)
    |> Enum.reverse()
    |> Enum.map(&String.to_integer/1)
  end
end
