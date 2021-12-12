defmodule Day10Test do
  use ExUnit.Case, async: true
  alias FileReader
  doctest Day10

  alias Day10, as: Day

  @test_input "inputs/tests/day_10.txt"
  @real_input "inputs/day_10.txt"

  test "day 10 part 1" do
    assert 26397 =
             @test_input
             |> FileReader.read_file()
             |> Day.part_01()

    assert 392_139 =
             @real_input
             |> FileReader.read_file()
             |> Day.part_01()
  end

  test "day 10 part 2" do
    assert ["])}>", "}}]])})]", ")}>]})", "}}>}>))))", "]]}}]}]}>"]
           |> Enum.map(&String.split(&1, "", trim: true))
           |> Enum.map(&Day.weird_count/1) ==
             [294, 288_957, 5566, 1_480_781, 995_444]

    assert [294, 288_957, 5566, 1_480_781, 995_444]
           |> Day.find_middle_score() ==
             288_957

    assert 288_957 =
             @test_input
             |> FileReader.read_file()
             |> Day.part_02()

    assert 4_001_832_844 =
             @real_input
             |> FileReader.read_file()
             |> Day.part_02()
  end
end
