defmodule Day08 do
  @moduledoc """
  --- Seven Segment Search ---
  ---------------------
  You barely reach the safety of the cave when the whale smashes into the cave mouth, collapsing it. Sensors indicate another exit to this cave at a much greater depth, so you have no choice but to press on.

  """

  @wires %{
    0 => ["a", "b", "c", "e", "f", "g"],
    1 => ["c", "f"],
    2 => ["a", "c", "d", "e", "g"],
    3 => ["a", "c", "d", "f", "g"],
    4 => ["b", "c", "d", "f"],
    5 => ["a", "b", "d", "f", "g"],
    6 => ["a", "b", "d", "e", "f", "g"],
    7 => ["a", "c", "f"],
    8 => ["a", "b", "c", "d", "e", "f", "g"],
    9 => ["a", "b", "c", "d", "f", "g"]
  }
  @wires_uniq_sizes %{
    2 => 1,
    4 => 4,
    3 => 7,
    7 => 8
  }

  @doc """
  As your submarine slowly makes its way through the cave system, you notice that the four-digit seven-segment displays in your submarine are malfunctioning; they must have been damaged during the escape. You'll be in a lot of trouble without them, so you'd better figure out what's wrong.

  Each digit of a seven-segment display is rendered by turning on or off any of seven segments named a through g:
  ```
    0:      1:      2:      3:      4:
  aaaa    ....    aaaa    aaaa    ....
  b    c  .    c  .    c  .    c  b    c
  b    c  .    c  .    c  .    c  b    c
  ....    ....    dddd    dddd    dddd
  e    f  .    f  e    .  .    f  .    f
  e    f  .    f  e    .  .    f  .    f
  gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
  aaaa    aaaa    aaaa    aaaa    aaaa
  b    .  b    .  .    c  b    c  b    c
  b    .  b    .  .    c  b    c  b    c
  dddd    dddd    ....    dddd    dddd
  .    f  e    f  .    f  e    f  .    f
  .    f  e    f  .    f  e    f  .    f
  gggg    gggg    ....    gggg    gggg
  ```

  So, to render a 1, only segments c and f would be turned on; the rest would be off. To render a 7, only segments a, c, and f would be turned on.

  The problem is that the signals which control the segments have been mixed up on each display. The submarine is still trying to display numbers by producing output on signal wires a through g, but those wires are connected to segments randomly. Worse, the wire/segment connections are mixed up separately for each four-digit display! (All of the digits within a display use the same connections, though.)

  So, you might know that only signal wires b and g are turned on, but that doesn't mean segments b and g are turned on: the only digit that uses two segments is 1, so it must mean segments c and f are meant to be on. With just that information, you still can't tell which wire (b/g) goes to which segment (c/f). For that, you'll need to collect more information.

  For each display, you watch the changing signals for a while, make a note of all ten unique signal patterns you see, and then write down a single four digit output value (your puzzle input). Using the signal patterns, you should be able to work out which pattern corresponds to which digit.

  For example, here is what you might see in a single entry in your notes:
  ```
  acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
  cdfeb fcadb cdfeb cdbaf
  ```
  (The entry is wrapped here to two lines so it fits; in your notes, it will all be on a single line.)

  Each entry consists of ten unique signal patterns, a | delimiter, and finally the four digit output value. Within an entry, the same wire/segment connections are used (but you don't know what the connections actually are). The unique signal patterns correspond to the ten different ways the submarine tries to render a digit using the current wire/segment connections. Because 7 is the only digit that uses three segments, dab in the above example means that to render a 7, signal lines d, a, and b are on. Because 4 is the only digit that uses four segments, eafb means that to render a 4, signal lines e, a, f, and b are on.

  Using this information, you should be able to work out which combination of signal wires corresponds to each of the ten digits. Then, you can decode the four digit output value. Unfortunately, in the above example, all of the digits in the output value (cdfeb fcadb cdfeb cdbaf) use five segments and are more difficult to deduce.
  For now, focus on the easy digits. Consider this larger example:
  ```
    be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb |
  fdgacbe cefdb cefbgd gcbe
  edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec |
  fcgedb cgb dgebacf gc
  fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef |
  cg cg fdcagb cbg
  fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega |
  efabcd cedba gadfec cb
  aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga |
  gecf egdcabf bgf bfgea
  fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf |
  gebdcfa ecba ca fadegcb
  dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf |
  cefg dcbef fcge gbcadfe
  bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd |
  ed bcgafe cdgba cbgef
  egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg |
  gbdfcae bgc cg cgb
  gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc |
  fgae cfgab fg bagce
  ```
    ecause the digits 1, 4, 7, and 8 each use a unique number of segments, you should be able to tell which combinations of signals correspond to those digits. Counting only digits in the output values (the part after | on each line), in the above example, there are 26 instances of digits that use a unique number of segments (highlighted above).

  ## In the output values, how many times do digits 1, 4, 7, or 8 appear?


  """
  def part_01(input) do
    input
    |> Enum.to_list()
    |> Enum.map(&find_easy_digits/1)
    |> List.flatten()
    |> Enum.count()
  end

  defp find_easy_digits(list) do
    list
    |> Enum.filter(fn digits -> String.length(digits) not in [5, 6] end)
    |> Enum.filter(fn digits ->
      @wires
      |> Enum.filter(fn {_, wires} ->
        digits
        |> String.split("", trim: true)
        |> Enum.all?(fn x -> x in wires end)
      end)
      |> Enum.map(fn {n, _} -> {digits, n} end)
      |> Enum.to_list()
    end)
  end

  @doc """
  Through a little deduction, you should now be able to determine the remaining digits. Consider again the first example above:

  ```
  acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab |
  cdfeb fcadb cdfeb cdbaf
  ```
  After some careful analysis, the mapping between signal wires and segments only make sense in the following configuration:
  ```
  dddd
  e    a
  e    a
  ffff
  g    b
  g    b
  cccc
  ```
  So, the unique signal patterns would correspond to the following digits:

  ```
  acedgfb: 8
  cdfbe: 5
  gcdfa: 2
  fbcad: 3
  dab: 7
  cefabd: 9
  cdfgeb: 6
  eafb: 4
  cagedb: 0
  ab: 1
  ```
  Then, the four digits of the output value can be decoded:

  ```
  cdfeb: 5
  fcadb: 3
  cdfeb: 5
  cdbaf: 3
  ```
  Therefore, the output value for this entry is 5353.

  Following this same process for each entry in the second, larger example above, the output value of each entry can be determined:

  ```
  fdgacbe cefdb cefbgd gcbe: 8394
  fcgedb cgb dgebacf gc: 9781
  cg cg fdcagb cbg: 1197
  efabcd cedba gadfec cb: 9361
  gecf egdcabf bgf bfgea: 4873
  gebdcfa ecba ca fadegcb: 8418
  cefg dcbef fcge gbcadfe: 4548
  ed bcgafe cdgba cbgef: 1625
  gbdfcae bgc cg cgb: 8717
  fgae cfgab fg bagce: 4315
  ```

  Adding all of the output values in this larger example produces 61229.

  For each entry, determine all of the wire/segment connections and decode the four-digit output values.
  ## What do you get if you add up all of the output values?

  """
  def part_02(input) do
    resolved =
      input
      |> Enum.map(fn [x, y] ->
        [
          x
          |> Enum.zip([nil, nil, nil, nil, nil, nil, nil, nil, nil, nil])
          |> Enum.into(%{}),
          y
        ]
      end)

    resolved
    |> Enum.map(&find_easy_digits_on_keys/1)
    |> Enum.map(&find_difficult_digits/1)
    |> Enum.map(&find_four_digits/1)
  end

  defp same?(pattern, ref) do
    ref
    |> String.split("", trim: true)
    |> Enum.sort() ==
      pattern
      |> String.split("", trim: true)
      |> Enum.sort()
  end

  defp pattern_has_same_length({k, _}, pattern),
    do: k |> String.length() == pattern |> String.length()

  defp same_pattern?({k, _}, pattern), do: same?(k, pattern)
  defp same_value?({_, v}, value), do: v == value

  defp find_difficult_digits([ten_patterns, patterns]) do
    [ten_patterns, patterns]
    |> find_2_3_5_digits
    |> find_0_6_9_digits
  end

  defp find_four_digits([ten_patterns, patterns]) do
    patterns
    |> Enum.map(fn pattern ->
      ten_patterns
      |> Enum.filter(&pattern_has_same_length(&1, pattern))
      |> Enum.filter(&same_pattern?(&1, pattern))
      |> List.first()
    end)
    |> Enum.map(fn {_, c} -> c end)
    |> Enum.join()
  end

  defp diff(f, s) do
    f
    |> String.splitter(
      s
      |> String.split("", trim: true),
      trim: true
    )
    |> Enum.join()
  end

  defp get(ten_patterns, value) do
    ten_patterns
    |> Enum.filter(&same_value?(&1, value))
    |> List.first()
    |> elem(0)
  end

  defp find_2_3_5_digits([ten_patterns, four_patterns]) do
    one = ten_patterns |> get(1)
    four = ten_patterns |> get(4)

    possible_values =
      ten_patterns
      |> Enum.filter(fn {k, v} -> String.length(k) == 5 and v == nil end)
      |> Enum.map(fn {k, _} -> k end)

    founds =
      {%{1 => one, 4 => four}, possible_values}
      |> find_result(3, &constraints_for_finding_3/2)
      |> find_result(5, &constraints_for_finding_5/2)
      |> find_result(2, &constraints_for_finding_2/2)
      |> format_result()

    [ten_patterns |> Map.merge(founds), four_patterns]
  end

  defp constraints_for_finding_3(possible_values, founds) do
    possible_values
    |> Enum.filter(fn possible_value ->
      diff(possible_value, Map.get(founds, 1))
      |> String.length() == 3
    end)
  end

  defp constraints_for_finding_5(possible_values, founds) do
    possible_values
    |> Enum.filter(fn possible_value ->
      possible_value != Map.get(founds, 3) and
        diff(possible_value, Map.get(founds, 4)) |> String.length() == 2
    end)
  end

  defp constraints_for_finding_2(possible_values, founds) do
    possible_values
    |> Enum.reject(fn x -> x in (Map.take(founds, [3, 5]) |> Map.values()) end)
  end

  defp constraints_for_finding_9(possible_values, founds) do
    possible_values
    |> Enum.filter(fn x -> diff(x, founds[3]) |> String.length() == 1 end)
  end

  defp constraints_for_finding_6(possible_values, founds) do
    possible_values
    |> Enum.filter(fn x -> x != founds[9] end)
    |> Enum.filter(fn x -> diff(x, founds[1]) |> String.length() == 5 end)
  end

  defp constraints_for_finding_0(possible_values, founds) do
    possible_values
    |> Enum.reject(fn x -> x in [founds[9], founds[6]] end)
  end

  defp format_result({result, _}) do
    result
    |> Enum.map(fn {k, v} -> {v, k} end)
    |> Map.new()
  end

  defp find_result({founds, possible_values}, n, constraints) do
    {
      founds
      |> Map.put(
        n,
        possible_values
        |> constraints.(founds)
        |> List.first()
      ),
      possible_values
    }
  end

  defp find_0_6_9_digits([ten_patterns, four_patterns]) do
    one = ten_patterns |> get(1)
    three = ten_patterns |> get(3)

    possible_values =
      ten_patterns
      |> Enum.filter(fn {_, v} -> v == nil end)
      |> Enum.map(fn {k, _} -> k end)

    founds =
      {%{1 => one, 3 => three}, possible_values}
      |> find_result(9, &constraints_for_finding_9/2)
      |> find_result(6, &constraints_for_finding_6/2)
      |> find_result(0, &constraints_for_finding_0/2)
      |> format_result()

    [ten_patterns |> Map.merge(founds), four_patterns]
  end

  defp find_easy_digits_on_keys([ten_patterns, four_patterns]) do
    found =
      ten_patterns
      |> Map.keys()
      |> find_easy_digits
      |> Enum.to_list()
      |> Enum.map(fn x -> {x, @wires_uniq_sizes |> Map.get(x |> String.length())} end)
      |> Enum.into(%{})

    [
      ten_patterns
      |> Map.merge(found),
      four_patterns
    ]
  end
end
