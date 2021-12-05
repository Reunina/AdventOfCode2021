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
      assert  ["first line", "1", "5.4", "é"] =
               """
               first line
               1
               5.4
               é
               """
               |> write_in_test_file()
               |> FileReader.read_file()
    end

    defp write_in_test_file(content) do
                                      @test_file |> File.write(content)
                                      @test_file
                                      end

  end

end
