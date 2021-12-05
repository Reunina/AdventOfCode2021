defmodule Day01Test do
  use ExUnit.Case, async: true
  alias FileReader
  doctest Day01

  @test_input "inputs/tests/day_01.txt"
  @real_input "inputs/day_01.txt"

  test "day 01 part 1" do
    assert 7 =
             @test_input
             |> FileReader.read_file(:as_int)
             |> Day01.part_01()

    assert 1521 =
             @real_input
             |> FileReader.read_file(:as_int)
             |> Day01.part_01()
  end

  test "day 01 part 2" do
    assert 5 =
             @test_input
             |> FileReader.read_file(:as_int)
             |> Day01.part_02()

    assert 1543 =
             @real_input
             |> FileReader.read_file(:as_int)
             |> Day01.part_02()
  end
end
