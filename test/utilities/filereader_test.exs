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
      ["string not_int", "3 not_int", "string 23.3"]
      |> Enum.each(fn wrong_input_on_integer ->
        assert_raise ArgumentError,
                     "errors were found at the given arguments:\n\n  * 1st argument: not a textual representation of an integer\n",
                     fn ->
                       wrong_input_on_integer
                       |> write_in_test_file()
                       |> FileReader.read_file(:as_string_and_int)
                     end
      end)

      ["string with spaces 2"]
      |> Enum.each(fn wrong_input_on_string ->
        assert_raise FunctionClauseError,
                     "no function clause matching in anonymous fn/1 in FileReader.read_file/2",
                     fn ->
                       wrong_input_on_string
                       |> write_in_test_file()
                       |> FileReader.read_file(:as_string_and_int)
                     end
      end)

      assert [
               ["1", 1],
               ["another_string", 12]
             ] =
               """
               1 1
               another_string 12
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
