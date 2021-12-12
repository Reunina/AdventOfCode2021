defmodule Day09Test do
  use ExUnit.Case, async: true
  alias FileReader
  doctest Day09

  alias Day09, as: Day

  @test_input "inputs/tests/day_09.txt"
  @real_input "inputs/day_09.txt"

  test "day 09 part 1" do
    assert 15 =
             @test_input
             |> extract_data()
             |> Day.part_01()

    assert 537 =
             @real_input
             |> extract_data()
             |> Day.part_01()
  end

  test "day 09 part 2" do
    assert 1134 =
             @test_input
             |> extract_data()
             |> Day.part_02()

    assert 1_142_757 =
             @real_input
             |> extract_data()
             |> Day.part_02()
  end

  defp extract_data(filename) do
    filename
    |> FileReader.read_with_function(&toto/1)
    |> Enum.to_list()
  end

  defp toto(line) do
    line
    |> String.replace("\n", "")
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
