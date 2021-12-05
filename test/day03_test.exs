defmodule Day03Test do
  use ExUnit.Case
  alias FileReader
  doctest Day03

  alias Day03, as: Day

  @test_input "inputs/tests/day_03.txt"
  @real_input "inputs/day_03.txt"

  test "day 3 part 1" do
    assert 198 =
             @test_input
             |> FileReader.read_file(:as_ints_list)
             |> Day.part_01()

    assert 3_309_596 =
             @real_input
             |> FileReader.read_file(:as_ints_list)
             |> Day.part_01()
  end

  test "day 3 part 2" do
    assert 230 =
             @test_input
             |> FileReader.read_file(:as_ints_list)
             |>Enum.to_list()
             |> Day.part_02()

    assert 2_981_085 =
             @real_input
             |> FileReader.read_file(:as_ints_list)
             |>Enum.to_list()
             |> Day.part_02()
  end
end
