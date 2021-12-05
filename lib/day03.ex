defmodule Day03 do
  @moduledoc """
  module doc TBD
  """

  @doc """
  part_01 doc TBD
  """
  def part_01(input) do
    gamma_rate =
      input
      |> get_bits()
      |> Enum.map(&most_common_in/1)

    epsilon_rate =
      gamma_rate
      |> Enum.map(&reverse_bit/1)
      |> to_integer

    epsilon_rate * (gamma_rate |> to_integer)
  end

  defp reverse_bit(0), do: 1
  defp reverse_bit(1), do: 0

  @doc """
  part_02 doc TBD
  """
  def part_02(input) do
    oxygen_generator_rating = input |> reduce_filtering(&filter_on_most_common/2) |> to_integer
    co2_scrubber_rating = input |> reduce_filtering(&filter_on_least_common/2) |> to_integer
    oxygen_generator_rating * co2_scrubber_rating
  end

  defp most_common_in(x), do: if(Enum.count(x) * 0.5 > Enum.sum(x), do: 0, else: 1)
  defp least_common_in(x), do: if(Enum.count(x) * 0.5 <= Enum.sum(x), do: 0, else: 1)

  defp filter_on_most_common([a], _), do: [a]

  defp filter_on_most_common(input, index) do
    input
    |> Enum.filter(fn x ->
      x |> Enum.at(index) ==
        input
        |> get_bit_at(index)
        |> most_common_in()
    end)
  end

  def filter_on_least_common([a], _), do: [a]

  def filter_on_least_common(input, index) do
    least_common = input |> get_bit_at(index) |> least_common_in

    input
    |> Enum.filter(fn x -> x |> Enum.at(index) == least_common end)
  end

  defp reduce_filtering(input, function) do
    input
    |> Enum.reduce(
      {input, 0},
      fn _, {res, index} ->
        {function.(res, index), index + 1}
      end
    )
    |> elem(0)
    |> List.flatten()
  end

  defp get_bits(input) do
    input
    |> Enum.zip_reduce([], fn elements, acc -> [elements | acc] end)
    |> Enum.reverse()
  end

  defp get_bit_at(input, index) do
    input
    |> get_bits()
    |> Enum.at(index)
  end

  defp to_integer(bit),
    do:
      bit
      |> Enum.join()
      |> Integer.parse(2)
      |> elem(0)
end
