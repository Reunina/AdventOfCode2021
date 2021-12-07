defmodule Day07Test do
  use ExUnit.Case, async: true
  alias FileReader
  doctest Day07

  alias Day07, as: Day

  @test_input "inputs/tests/day_07.txt"
  @real_input "inputs/day_07.txt"

  test "day 07 part 1" do
    assert 37 =
             @test_input
             |> FileReader.read_file(:as_ints_list, separator: ",")
             |> Day.part_01()

    assert 325_528 =
             @real_input
             |> FileReader.read_file(:as_ints_list, separator: ",")
             |> Day.part_01()
  end

  test "day 07 part 2" do
    assert 168 =
             @test_input
             |> FileReader.read_file(:as_ints_list, separator: ",")
             |> Day.part_02()

    assert 85_015_836 =
             @real_input
             |> FileReader.read_file(:as_ints_list, separator: ",")
             |> Day.part_02()
  end
end
