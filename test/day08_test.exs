defmodule Day08Test do
  use ExUnit.Case, async: true
  alias FileReader
  doctest Day08

  alias Day08, as: Day

  @test_input "inputs/tests/day_08.txt"
  @test_input_small "inputs/tests/day_08_small.txt"
  @test_input_small_2 "inputs/tests/day_08_small_02.txt"
  @test_input_small_3 "inputs/tests/day_08_small_03.txt"
  @test_input_small_5 "inputs/tests/day_08_small_05.txt"
  @test_input_small_7 "inputs/tests/day_08_small_07.txt"
  @real_input "inputs/day_08.txt"

  test "day 08 part 1" do

    assert 26 =
             @test_input
             |> FileReader.read_with_function(&read_parameters_only_four_digits/1)
             |> Day.part_01()

    assert 397 =
             @real_input
             |> FileReader.read_with_function(&read_parameters_only_four_digits/1)
             |> Day.part_01()
  end

  test "day 08 part 2" do
    assert ["4873"] =
             @test_input_small_5
             |> FileReader.read_with_function(&read_parameters/1)
             |> Day.part_02()

    assert ["8394"] =
             @test_input_small_3
             |> FileReader.read_with_function(&read_parameters/1)
             |> Day.part_02()

    assert ["5353"] =
             @test_input_small
             |> FileReader.read_with_function(&read_parameters/1)
             |> Day.part_02()

    assert ["1197"] =
             @test_input_small_2
             |> FileReader.read_with_function(&read_parameters/1)
             |> Day.part_02()

    assert ["4548"] =
             @test_input_small_7
             |> FileReader.read_with_function(&read_parameters/1)
             |> Day.part_02()

    assert 61229 ==
             @test_input
             |> FileReader.read_with_function(&read_parameters/1)
             |> Day.part_02()
             |> Enum.map(fn d -> String.to_integer(d) end)
             |> Enum.sum()

    assert 1_027_422 =
             @real_input
             |> FileReader.read_with_function(&read_parameters/1)
             |> Day.part_02()
             |> Enum.map(fn d -> String.to_integer(d) end)
             |> Enum.sum()
  end

  defp read_parameters(line) do
    [unique_signal_patterns, four_digit_output_value] =
      line
      |> String.replace("\n", "")
      |> String.split(" | ", trim: true)

    [
      unique_signal_patterns |> String.split(" ", trim: true),
      four_digit_output_value |> String.split(" ", trim: true)
    ]
  end

  defp read_parameters_only_four_digits(line) do
    [_, four_digit_output_value] =
      line
      |> String.replace("\n", "")
      |> String.split(" | ", trim: true)

    four_digit_output_value |> String.split(" ", trim: true)
  end
end
