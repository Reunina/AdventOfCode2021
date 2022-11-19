defmodule Day14Test do
  use ExUnit.Case, async: true
  alias FileReader
  doctest Day14

  alias Day14, as: Day

  @test_input "inputs/tests/day_14.txt"
  @test_input_small "inputs/tests/day_14.small_test.txt"
  @real_input "inputs/day_14.txt"

  test "day 14 part 1" do
    assert ["N", "C", "N", "B", "C", "H", "B"] =
             @test_input_small
             |> Day.extract_data()
             |> Day.part_01(1)
             |> Enum.reject(& &1 == "")

    assert ["N", "B", "C", "C", "N", "B", "B", "B", "C", "B", "H", "C", "B"] =
             @test_input
             |> Day.extract_data()
             |> Day.part_01(2)
             |> Enum.reject(& &1 == "")

             nb_steps=10
    {{_, min}, {_, max}} =
      @test_input
      |> Day.extract_data()
      |> Day.part_01(nb_steps)
      |> Enum.frequencies()
      |> IO.inspect(label: "freqtest_input")
      |> Enum.min_max_by(fn {x, y} -> y end)
      |> IO.inspect(label: "freqtest_input")

    assert 1_588 = max - min

    {{_, mina}, {_, maxa}} =
      @real_input
      |> Day.extract_data()
      |> Day.part_01(nb_steps)
      |> Enum.frequencies()
      |> IO.inspect(label: "freq")
      |> Enum.min_max_by(fn {x, y} -> y end)

    assert 2_223 = maxa - mina
  end

  test "day 14 part 2" do
    nb_steps = 40
    {{_, mina}, {_, maxa}} =
      @test_input
      |> Day.extract_data()
      |> Day.part_02(nb_steps)
      |> Enum.min_max_by(fn {x, y} -> y end)
      |> IO.inspect(label: " frequencoies")

    assert 2_188_189_693_529 = maxa - mina

    {{_, mina}, {_, maxa}} =
      @real_input
      |> Day.extract_data()
      |> Day.part_02(nb_steps)
      |> Enum.min_max_by(fn {x, y} -> y end)

    assert 2_566_282_754_493 = maxa - mina
  end
end
