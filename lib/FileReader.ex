defmodule FileReader do
  def read_file(file_name, :as_list_string_int) do
    File.stream!(file_name)
    |> Enum.map(fn line -> String.split(line) end)
    |> Enum.map(fn [a, b] -> [a, b |> Integer.parse() |> elem(0)] end)
  end

  def read_file(file_name, :as_int) do
    File.stream!(file_name)
    |> Enum.map(fn line -> String.trim(line) |> String.to_integer() end)
  end

  def read_file(file_name) do
    File.stream!(file_name)
    |> Enum.map(fn line -> String.trim(line) end)
  end
end
