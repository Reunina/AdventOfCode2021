defmodule Day05Test do
  use ExUnit.Case
  alias FileReader
  doctest Day05

  alias Day05, as: Day

  @test_input "inputs/tests/day_05.txt"
  @real_input "inputs/day_05.txt"

  describe "Day 05 should" do
    test "day 05 part 1" do
      assert 5 =
               @test_input
               |> FileReader.read_file()
               |> Enum.to_list()
               |> Day.part_01()

      assert 5698 =
               @real_input
               |> FileReader.read_file()
               |> Enum.to_list()
               |> Day.part_01()
    end

    test "day 05 part 2" do
      assert 12 =
               @test_input
               |> FileReader.read_file()
               |> Enum.to_list()
               |> Day.part_02()

      assert 15463 =
               @real_input
               |> FileReader.read_file()
               |> Enum.to_list()
               |> Day.part_02()
    end
  end

  describe "Day 05 part01 should:" do
    test "extract and format line segments from input " do
      assert [x1: 0, y1: 9, x2: 5, y2: 9] =
               "0,9 -> 5,9"
               |> Day.format_to_line_segments()

      assert [
               [x1: 0, y1: 9, x2: 5, y2: 9],
               [x1: 8, y1: 0, x2: 0, y2: 8],
               [x1: 9, y1: 4, x2: 3, y2: 4]
             ] =
               ["0,9 -> 5,9", "8,0 -> 0,8", " 9,4 -> 3,4"]
               |> Day.format_to_line_segments()
    end

    test "only consider horizontal and vertical lines " do
      assert [
               [x1: 0, y1: 9, x2: 5, y2: 9],
               [x1: 9, y1: 4, x2: 3, y2: 4]
             ] =
               ["0,9 -> 5,9", "8,0 -> 0,8", " 9,4 -> 3,4"]
               |> Day.format_to_line_segments()
               |> Day.keep_horizontal_and_vertical_lines()
    end

    test "generate all points from input  " do
      # An entry like 1,1 -> 1,3 covers points 1,1, 1,2, and 1,3.
      # An entry like 9,7 -> 7,7 covers points 9,7, 8,7, and 7,7.
      assert [[{1, 1}, {1, 2}, {1, 3}]] =
               ["1,1 -> 1,3"]
               |> Day.format_to_line_segments()
               |> Day.keep_horizontal_and_vertical_lines()
               |> Day.generate_all_wind_points()

      assert [[{9, 7}, {8, 7}, {7, 7}]] =
               ["9,7 -> 7,7"]
               |> Day.format_to_line_segments()
               |> Day.keep_horizontal_and_vertical_lines()
               |> Day.generate_all_wind_points()

      assert [
               [
                 {0, 9},
                 {1, 9},
                 {2, 9},
                 {3, 9},
                 {4, 9},
                 {5, 9}
               ],
               [
                 {9, 4},
                 {8, 4},
                 {7, 4},
                 {6, 4},
                 {5, 4},
                 {4, 4},
                 {3, 4}
               ]
             ] =
               ["0,9 -> 5,9", "8,0 -> 0,8", " 9,4 -> 3,4"]
               |> Day.format_to_line_segments()
               |> Day.keep_horizontal_and_vertical_lines()
               |> Day.generate_all_wind_points()
    end
  end

  describe "Day 05 part02 should:" do
    test "only consider horizontal and vertical and diags lines " do
      assert [
               [x1: 0, y1: 9, x2: 5, y2: 9],
               [x1: 8, y1: 0, x2: 0, y2: 8],
               [x1: 9, y1: 4, x2: 3, y2: 4]
             ] =
               ["0,9 -> 5,9", "8,0 -> 0,8", " 9,4 -> 3,4"]
               |> Day.format_to_line_segments()
               |> Day.keep_horizontal_and_vertical_and_45_degrees_lines()
    end

    test "generate all wind points " do
      # An entry like 1,1 -> 1,3 covers points 1,1, 1,2, and 1,3.
      # An entry like 9,7 -> 7,7 covers points 9,7, 8,7, and 7,7.
      assert [[{6, 4}, {5, 3}, {4, 2}, {3, 1}, {2, 0}]] ==
               [[x1: 6, y1: 4, x2: 2, y2: 0]]
               |> Day.keep_horizontal_and_vertical_and_45_degrees_lines()
               |> Day.generate_all_wind_points()
    end
  end
end
