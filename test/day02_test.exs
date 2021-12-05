defmodule Day02Test do
  use ExUnit.Case
  alias FileReader
  doctest Day02

  alias Day02, as: Day

  @test_input "inputs/tests/day_02.txt"
  @real_input "inputs/day_02.txt"

  test "day 02 part 1" do
    assert 150 =
             @test_input
             |> FileReader.read_file(:as_string_and_int)
             |> Day.part_01()

    assert 2_070_300 =
             @real_input
             |> FileReader.read_file(:as_string_and_int)
             |> Day.part_01()
  end

  test "day 02 part 2" do
    assert 900 =
             @test_input
             |> FileReader.read_file(:as_string_and_int)
             |> Day.part_02()

    assert 2_078_985_210 =
             @real_input
             |> FileReader.read_file(:as_string_and_int)
             |> Day.part_02()
  end
end
