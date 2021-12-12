defmodule Day11Test do
  use ExUnit.Case, async: true
  alias FileReader
  doctest Day11

  alias Day11, as: Day

  @test_input "inputs/tests/day_11.txt"
  @real_input "inputs/day_11.txt"

  test "day 11 part 1" do
    assert 204 =
             @test_input
             |> FileReader.read_file(:as_ints_list)
             |> Day.part_01(10)

    assert 1656 =
             @test_input
             |> FileReader.read_file(:as_ints_list)
             |> Day.part_01(100)

    assert 1717 =
             @real_input
             |> FileReader.read_file(:as_ints_list)
             |> Day.part_01()
  end

  test "day 11 part 2" do
    assert 195 =
             @test_input
             |> FileReader.read_file(:as_ints_list)
             |> Day.part_02()

    assert 476 =
             @real_input
             |> FileReader.read_file(:as_ints_list)
             |> Day.part_02(100_000)
  end
end
