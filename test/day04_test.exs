defmodule Day04Test do
  use ExUnit.Case, async: true
  alias FileReader
  doctest Day04

  alias Day04, as: Day

  @test_input "inputs/tests/day_04.txt"
  @real_input "inputs/day_04.txt"

  test "day 04 part 1" do
    assert 4512 =
             @test_input
             |> FileReader.read_file()
             |> extract_parameters()
             |> Day.part_01()

    assert 74320 =
             @real_input
             |> FileReader.read_file()
             |> extract_parameters()
             |> Day.part_01()
  end

  test "day 04 part 2" do
    assert 1924 =
             @test_input
             |> FileReader.read_file()
             |> extract_parameters()
             |> Day.part_02()

    assert 17884 ==
             @real_input
             |> FileReader.read_file()
             |> extract_parameters()
             |> Day.part_02()
  end

  defp extract_parameters(stream) do
    [head | tail] = stream |> Enum.to_list()

    %{
      numbers: extract_numbers(head),
      boards: extracts_boards(tail)
    }
  end

  defp extract_numbers(head) do
    head
    |> String.replace("\n", "")
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp extracts_boards(tail) do
    tail
    |> Stream.filter(fn x -> x != "" end)
    |> Stream.chunk_every(5)
    |> Enum.map(fn x ->
      x
      |> Enum.map(fn y ->
        String.split(y, " ", trim: true)
      end)
    end)
  end
end
