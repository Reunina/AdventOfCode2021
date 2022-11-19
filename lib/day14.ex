defmodule Day14 do
  @moduledoc """
  module doc TBD
  """

  @doc """
  part_01 doc TBD
  """
  def part_01({polymer_template, insertions}, steps \\ 10) do
    {polymer_template, insertions} |> IO.inspect(label: "KKK")

    1..steps
    |> Enum.reduce(
      polymer_template,
      fn step, polymer ->
        step |> IO.inspect(label: "-- step")

        polymer
        |> Enum.chunk_every(2, 1)
        |> Enum.map(fn
          [a, _] = ab -> [a, insertions |> Map.get(Enum.join(ab, ""), "")]
          [b] -> [b]
        end)
        |> List.flatten()
        |> IO.inspect(label: "kk")
      end
    )
  end

  def part_02({polymer_template, insertions}, steps \\ 40) do
    {polymer_template, insertions}
    insertions |> IO.inspect(label: "insertions")

    polymer_template =
      polymer_template
      |> Enum.chunk_every(2, 1)
      |> Enum.frequencies()
      |> Map.new()
      |> IO.inspect(label: "polymer_template")

    ddd=polymer_template
        |> Enum.filter(fn {pair, _} -> Enum.count(pair) == 1  end)
        |> IO.inspect(label: "-- end > Enum.count(pair) == 1")

    temp =
      1..steps
      |> Enum.reduce(
        polymer_template,
        fn step, step_polymer ->
          step_polymer |> IO.inspect(label: "STEPPP N#{step}")

          step_polymer
          |> Enum.map(
          fn
            {[a], count } -> {[a], count }
            {[a,b], 0 } -> { }
            {[a,b], count } ->
              lll =  Map.get(insertions, Enum.join([a,b],""), "")
              lll |> IO.inspect(label: "-  llll")
              if lll != "" do
                        letter =  Map.get(insertions, Enum.join([a,b],""), "")
                                 [
                                   {[a,b], 0 },
                                   {[a,letter], count },
                                   {[letter,b], count }
                                 ]
                               else
                                 {[a,b], count }
                               end
          end

             )|> IO.inspect(label: "-  gnannaaa")

          |> List.flatten()
          |> Enum.reduce(%{}, fn
            {[ b], count}, acc -> acc
            {}, acc -> acc
            {[a, b], count}, acc ->
            acc |> Map.update([a, b], count, fn e -> e + count end)
          end)
          |> IO.inspect(label: "-- end Enum.reduce STEP#{step}")

        end
      )


    temp
    |> Enum.concat(ddd)
    |> IO.inspect(label: "-- steENDp A }")
    |> Enum.map(fn { list , freq} -> {List.first(list), freq} end)
    |> IO.inspect(label: "-- steENDp }")
    |> Enum.reduce(%{}, fn
      {a, freq}, acc ->
        acc
        |> Map.update(a, freq, fn e -> e + freq end)
    end)
    |> IO.inspect(label: "-- steENDp }")


  end


  def dd([a, b] = pair, pol, letter) do
    p1 = [a, letter]
    p2 = [letter, b]

    {p1,p2}   |> IO.inspect(label: "          ---{p1,p2} }")

    pair_freq = Map.get(pol, [a, b], 0)
                |> IO.inspect(label: "                    pair_freq")
    p1_freq = Map.get(pol, p1, 0 )
              |> IO.inspect(label: "                    p1_freq  ")
    p2_freq = Map.get(pol, p2, 0  )
              |> IO.inspect(label: "                    p2_freq  ")
    [
      {pair, 0},
      {p1, pair_freq + p1_freq},
      {p2, pair_freq + p1_freq }
    ]
    |> IO.inspect(label: "-- new MAP")
  end

  def extract_data(filename) do
    data =
      filename
      |> FileReader.read_file()
      |> Enum.to_list()

    polymer_template =
      List.first(data)
      |> String.split("", trim: true)

    insertions =
      data
      |> Enum.drop(2)
      |> Enum.reject(fn x -> x == "" end)
      |> Enum.map(fn line -> line |> String.split(" -> ", trim: true) |> List.to_tuple() end)
      |> Map.new()

    {polymer_template, insertions}
  end

  defp format_fold_instructions(instructions) do
    [_, _, x_or_y, val] = instructions |> String.split([" ", "="], trim: true)
    {x_or_y, String.to_integer(val)}
  end

  defp format_coordinates(coordinates) do
    coordinates
    |> String.split(",", trim: true)
    |> Enum.reverse()
    |> Enum.map(&String.to_integer/1)
  end
end
