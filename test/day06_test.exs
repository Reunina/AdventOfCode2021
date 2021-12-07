defmodule Day06Test do
  use ExUnit.Case, async: true
  alias FileReader
  doctest Day06

  alias Day06, as: Day

  @test_input "inputs/tests/day_06.txt"
  @real_input "inputs/day_06.txt"

  test "day 06 part 1" do
    assert 26 =
             @test_input
             |> FileReader.read_file(:as_ints_list, separator: ",")
             |> Day.part_01(18)

    assert 5934 =
             @test_input
             |> FileReader.read_file(:as_ints_list, separator: ",")
             |> Day.part_01()

    assert 356_190 =
             @real_input
             |> FileReader.read_file(:as_ints_list, separator: ",")
             |> Day.part_01()

    assert 26_984_457_539 =
             @test_input
             |> FileReader.read_file(:as_ints_list, separator: ",")
             |> Day.part_02()

    assert 1_617_359_101_538 =
             @real_input
             |> FileReader.read_file(:as_ints_list, separator: ",")
             |> Day.part_02()
  end
end
