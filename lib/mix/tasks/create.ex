defmodule Mix.Tasks.Create do
  @moduledoc "Create All files for an Advent of code's day puzzle and download puzzle input"
  use Mix.Task

  @doc """

  ## Example


   ```
  mix create "02"
  #   * creating inputs/day_02.txt
  #   * creating inputs/tests/day_02.txt
  #   * creating test/day02_test.exs
  #   * creating lib/day02.ex


   ```

  """

  def run(days) do
    days
    |> Enum.each(&create_files_for/1)
  end

  defp create_files_for(day) do
    day
    |> create_input_files()
    |> create_test_file()
    |> create_implementation_file()
  end

  defp create_input_files(day) do
    day
    |> create_file(:input)
    |> create_file(:input_test)
  end

  defp create_test_file(day) do
    day
    |> create_file(:test)
  end

  defp create_implementation_file(day) do
    day
    |> create_file(:implementation)
  end

  defp create_file(day, :implementation) do
    "lib/day#{day}.ex"
    |> write_file("""
    defmodule Day#{day} do

      @moduledoc \"""
      module doc TBD
      \"""

      @doc \"""
      part_01 doc TBD
      \"""
      def part_01(input) do
      end

      @doc \"""
      part_02 doc TBD
      \"""
      def part_02(input) do
      end
    end
    """)

    day
  end

  defp create_file(day, :test) do
    "test/day#{day}_test.exs"
    |> write_file("""
    defmodule Day#{day}Test do
       use ExUnit.Case, async: true
      alias FileReader
      doctest Day#{day}

      alias Day#{day}, as: Day

      @test_input "inputs/tests/day_#{day}.txt"
      @real_input "inputs/day_#{day}.txt"

      test "day #{day} part 1" do
        assert 0 =
             @test_input
             |> FileReader.read_file()
             |> Day.part_01()

        assert 0 =
             @real_input
             |> FileReader.read_file()
             |> Day.part_01()
      end

      test "day #{day} part 2" do
        assert 0 =
               @test_input
               |> FileReader.read_file()
               |> Day.part_02()

        assert 0 =
               @real_input
               |> FileReader.read_file()
               |> Day.part_02()
      end
    end
    """)

    day
  end

  defp create_file(day, :input) do
    "inputs/day_#{day}.txt"
    |> write_file(download_input!(day, 2021))

    day
  end

  defp create_file(day, :input_test) do
    "inputs/tests/day_#{day}.txt"
    |> write_file("")

    day
  end

  defp write_file(filename, content) do
    IO.puts("* creating #{filename}")
    {:ok, file} = File.open(filename, [:write])
    IO.write(file, content)
  end

  defp download_input!(day, year) do
    {:ok, {{'HTTP/1.1', 200, 'OK'}, _, input}} =
      :httpc.request(
        :get,
        {'https://adventofcode.com/#{year}/day/#{day |> Integer.parse() |> elem(0)}/input',
         headers()},
        [],
        []
      )

    input
  end

  defp headers,
    do: [
      {'cookie',
       String.to_charlist(
         "session=" <>
           "53616c7465645f5fb330cdc518605f4c06630e717c4332e6ec0f22f0e37589caf3bd211d636e1d1d6714d90a8f83cb91"
       )}
    ]
end
