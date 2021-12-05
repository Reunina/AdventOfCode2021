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
               |> Enum.to_list()
    end

    test "read simply input as integers" do
      assert [1, 2, 3] =
               """
               1
               2
               3
               """
               |> write_in_test_file()
               |> FileReader.read_file(:as_int)
               |> Enum.to_list()

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
                     |> Enum.to_list()
                   end
    end

    test "read simply input as a string and a int" do
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
               |> Enum.to_list()

      ["string not_int", "3 not_int", "string 23.3"]
      |> Enum.each(fn wrong_input_on_integer ->
        assert_raise ArgumentError,
                     "errors were found at the given arguments:\n\n  * 1st argument: not a textual representation of an integer\n",
                     fn ->
                       wrong_input_on_integer
                       |> write_in_test_file()
                       |> FileReader.read_file(:as_string_and_int)
                       |> Enum.to_list()
                     end
      end)

      ["string with spaces 2"]
      |> Enum.each(fn wrong_input_on_string ->
        assert_raise ArgumentError,
                     "errors were found at the given arguments:\n\n  * 1st argument: not a textual representation of an integer\n",
                     fn ->
                       wrong_input_on_string
                       |> write_in_test_file()
                       |> FileReader.read_file(:as_string_and_int)
                       |> Enum.to_list()
                     end
      end)
    end

    defp write_in_test_file(content) do
      @test_file |> File.write(content)
      @test_file
    end
  end
end
