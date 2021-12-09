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
  def read_file(file_name, output_format, opts \\ [separator: ""])

  def read_file(file_name, :as_ints_list, opts) do
    file_name
    |> read_with_function(&to_list_of_integers(&1, opts[:separator]))
  end

  def read_file(file_name, :as_string_and_int, _opts) do
    file_name
    |> read_with_function(&to_string_and_int(&1))
  end

  def read_file(file_name, :as_int, _opts) do
    file_name
    |> read_with_function(&to_int(&1))
  end

  @doc """
  read input file as trimmed `string`

  Returns list.
  """
  def read_file(file_name) do
    file_name
    |> read_with_function(&String.trim(&1))
  end

  def read_with_function(filename, function) do
    filename
    |> File.stream!()
    |> Stream.map(&function.(&1))
  end

  defp to_string_and_int(line),
    do:
      line
      |> String.replace("\n", "")
      |> String.split(" ")
      |> update_in([Access.at(1)], fn b -> to_int(b) end)

  defp to_int(line), do: line |> String.trim() |> String.to_integer()

  defp to_list_of_integers(line, separator),
    do:
      line
      |> String.replace("\n", "")
      |> String.split(separator, trim: true)
      |> Enum.map(&String.to_integer/1)
end
