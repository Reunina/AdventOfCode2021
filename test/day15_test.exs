defmodule Day15Test do
  use ExUnit.Case, async: true
  alias FileReader
  doctest Day15

  alias Day15, as: Day

  @test_input "inputs/tests/day_15.txt"
  @real_input "inputs/day_15.txt"

  test "day 15 part 1" do

    assert 46 =
             @test_input
             |> Day.extract_data()
             |> Day.part_01()

    assert 429 =
             @real_input
             |> Day.extract_data()
             |> Day.part_01()
  end

  test "day 15 part 2" do
    assert 315 =
             @test_input
             |> Day.part_02()

    assert 2844 =
             @real_input
             |> Day.part_02()
  end
end
