defmodule Day12Test do
  use ExUnit.Case, async: true
  alias FileReader
  doctest Day12

  alias Day12, as: Day

  @test_input "inputs/tests/day_12.txt"
  @test_input_small "inputs/tests/day_12.small_exmaple.txt"
  @test_input_large "inputs/tests/day_12.larger_example.txt"
  @real_input "inputs/day_12.txt"

  test "day 12 part 1" do
    @test_input_small
    |> extract_data()
    |> Day.part_01("start")
    |> Visualizations.Graphcustom.run("test_input_small_part01")
    @test_input_small
    |> extract_data()
    |> Day.part_02("start")
    |> Visualizations.Graphcustom.run("test_input_small_part02")

    assert 10 =
             @test_input_small
             |> extract_data()
             |> Day.part_01("start")
             |> Enum.count()

    assert 19 =
             @test_input
             |> extract_data()
             |> Day.part_01("start")
             |> Enum.count()

    assert 226 =
             @test_input_large
             |> extract_data()
             |> Day.part_01("start")
             |> Enum.count()

    assert 3485 =
             @real_input
             |> extract_data()
             |> Day.part_01("start")
             |> Enum.count()
  end

  test "day 12 part 2" do
    assert 36 =
             @test_input_small
             |> extract_data()
             |> Day.part_02("start")
             |> Enum.count()

    assert 103 =
             @test_input
             |> extract_data()
             |> Day.part_02("start")
             |> Enum.count()

    assert 3509 =
             @test_input_large
             |> extract_data()
             |> Day.part_02("start")
             |> Enum.count()

    assert 85062 =
             @real_input
             |> extract_data()
             |> Day.part_02("start")
             |> Enum.count()
  end

  defp extract_data(filename) do
    paths =
      filename
      |> FileReader.read_with_function(&extract_to_segments/1)
      |> Enum.to_list()

    graph =
      paths
      |> Enum.reduce(%{}, fn [first, last], map ->
        map
        |> Map.update(first, MapSet.new([last]), fn existing -> existing |> MapSet.put(last) end)
        |> Map.update(last, MapSet.new([first]), fn existing -> existing |> MapSet.put(first) end)
      end)
      |> Map.new()

    {paths, graph}
  end

  def extract_to_segments(line) do
    line
    |> String.replace("\n", "")
    |> String.split("-", trim: true)
  end
end
