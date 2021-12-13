defmodule Day10 do
  @moduledoc """

  """
  @opening ["(", "<", "{", "["]
  @closing [")", ">", "}", "]"]
  @closing_for_openings Enum.zip(@closing, @opening) |> Enum.into(%{})
  @openings_for_closing Enum.zip(@opening, @closing) |> Enum.into(%{})

  @points %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }

  @points_p2 %{
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4
  }
  @doc """

  """
  def part_01(input) do
    input
    |> find_mismatches()
    |> apply_points(&classic_count/1)
    |> Enum.sum()
  end

  defp apply_points(mismatches, counter) do
    mismatches
    |> Enum.map(&counter.(&1))
  end

  def classic_count(characters),
    do:
      characters
      |> Enum.map(&Map.get(@points, &1, 0))
      |> Enum.sum()

  def weird_count(characters) do
    characters
    |> Enum.reduce(0, fn characters, score ->
      score * 5 + Map.get(@points_p2, characters, 0)
    end)
  end

  defp find_mismatches(lines) do
    lines
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
      |> Enum.reduce_while([], &find_first_illegal_character(&1, &2))
    end)
    |> Enum.reject(&is_atom/1)
  end

  defp find_first_illegal_character(current_character, rest) when current_character in @opening,
    do: {:cont, [current_character | rest]}

  defp find_first_illegal_character(current_character, [opening | rest])
       when current_character in @closing do
    if(opening == Map.get(@closing_for_openings, current_character)) do
      {:cont, rest}
    else
      {:halt, [current_character]}
    end
  end

  defp find_first_illegal_character(_, _), do: {:halt, :unfinished}

  def find_middle_score(scores) do
    where = (scores |> Enum.count()) / 2.0 - 0.5

    scores
    |> Enum.sort()
    |> Enum.at("#{where}" |> Integer.parse() |> elem(0))
  end

  @doc """
  """
  def part_02(input) do
    input
    |> find_mismatches()
    |> keep_incomplete_only()
    |> deduce_completing_sequences()
    |> apply_points(&weird_count/1)
    |> find_middle_score
  end

  defp deduce_completing_sequences(lines) do
    lines
    |> Enum.map(&Enum.reverse/1)
    |> Enum.map(
      &Enum.map(&1, fn closing_character -> Map.get(@openings_for_closing, closing_character) end)
    )
    |> Enum.map(&Enum.reverse/1)
  end

  defp keep_incomplete_only(lines) do
    lines |> Enum.reject(&(Enum.count(&1) == 1))
  end
end
