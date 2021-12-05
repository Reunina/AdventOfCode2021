defmodule FileReader do
  @moduledoc """
  File reader for AOC inputs
  """

  @doc """
  read input file and format it as `output_format` indicates
  Returns list.

  ## Example
  ```
      #=> in input_file :
      # a 12
      # z 9
      # u -5
      FileReader.read_file(input_file, :as_string_and_int)
      [ ["a", 12], ["z",  9], ["u", -5] ]

      #=> in input_file :
      # 12
      # 9
      # -5
      FileReader.read_file(input_file, :as_int)
      [ 12, 9, -5 ]
  ```
  """
  def read_file(file_name, output_format)

  def read_file(file_name, :as_ints_list) do
    file_name
    |> File.stream!()
    |> Enum.map(fn line ->
      line
      |> String.replace("\n", "")
      |> String.split("", trim: true)
      |> Enum.map(fn x -> String.to_integer(x) end)
    end)

  end

  def read_file(file_name, :as_string_and_int) do
    File.stream!(file_name)
    |> Enum.map(fn line -> String.split(line) end)
    |> Enum.map(fn [a, b] -> [a, b |> String.trim() |> String.to_integer()] end)
  end

  def read_file(file_name, :as_int) do
    file_name
    |> File.stream!()
    |> Enum.map(fn line -> line |> String.trim() |> String.to_integer() end)
  end

  @doc """
  read input file as trimmed `string`

  Returns list.
  """
  def read_file(file_name) do
    file_name
    |> File.stream!()
    |> Enum.map(&String.trim/1)
  end
end