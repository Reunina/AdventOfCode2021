defmodule FileReaderTest do
  use ExUnit.Case
  alias FileReader

  @test_file ".temp.FileReaderTest.txt"

  describe "FileReader should: " do
    setup do
      File.touch(@test_file)
      on_exit(fn -> File.rm!(@test_file) end)
    end

    test "read simply input as trimmed strings" do
      assert ["first line", "1", "5.4", "é"] =
               """
               first line
               1
               5.4
               é
               """
               |> write_in_test_file()
               |> FileReader.read_file()
    end

    test "read simply input as integers" do
      assert_raise ArgumentError,
                   "errors were found at the given arguments:\n\n  * 1st argument: not a textual representation of an integer\n",
                   fn ->
                     """
                     first line
                     1
                     5.4

                     é
                     """
                     |> write_in_test_file()
                     |> FileReader.read_file(:as_int)
                   end

      assert [1, 2, 3] =
               """
               1
               2
               3
               """
               |> write_in_test_file()
               |> FileReader.read_file(:as_int)
    end

    test "read simply input as a string and a int" do
      assert_raise ArgumentError,
                   "errors were found at the given arguments:\n\n  * 2nd argument: not a tuple\n",
                   fn ->
                     """
                     string not_int
                     """
                     |> write_in_test_file()
                     |> FileReader.read_file(:as_string_and_int)
                   end
      assert_raise ArgumentError,
                   "errors were found at the given arguments:\n\n  * 2nd argument: not a tuple\n",
                   fn ->
                     """
                     3 not_int
                     """
                     |> write_in_test_file()
                     |> FileReader.read_file(:as_string_and_int)
                   end
      assert_raise FunctionClauseError,
                   "no function clause matching in anonymous fn/1 in FileReader.read_file/2",
                   fn ->
                     """
                     string with spaces 2
                     """
                     |> write_in_test_file()
                     |> FileReader.read_file(:as_string_and_int)
                   end

      assert [
               ["1", 1],
               ["another_string", 12],
               ["string", 23]
             ] ="""
                        1 1
                        another_string 12
                        string 23.3
                        """
                        |> write_in_test_file()
                        |> FileReader.read_file(:as_string_and_int)
    end

    defp write_in_test_file(content) do
      @test_file |> File.write(content)
      @test_file
    end
  end
end
