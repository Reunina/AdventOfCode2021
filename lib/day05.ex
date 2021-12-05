defmodule Day05 do
  @moduledoc """
  # --- Hydrothermal Venture ---
  You come across a field of hydrothermal vents on the ocean floor! These vents constantly produce large, opaque clouds, so it would be best to avoid them if possible.
  """

  @doc """
  They tend to form in lines; the submarine helpfully produces a list of nearby lines of vents (your puzzle input) for you to review. For example:
  ```
  0,9 -> 5,9
  8,0 -> 0,8
  9,4 -> 3,4
  2,2 -> 2,1
  7,0 -> 7,4
  6,4 -> 2,0
  0,9 -> 2,9
  3,4 -> 1,4
  0,0 -> 8,8
  5,5 -> 8,2
  ```
  Each line of vents is given as a line segment in the format x1,y1 -> x2,y2 where x1,y1 are the coordinates of one end the line segment and x2,y2 are the coordinates of the other end. These line segments include the points at both ends. In other words:

  - An entry like 1,1 -> 1,3 covers points 1,1, 1,2, and 1,3.
  - An entry like 9,7 -> 7,7 covers points 9,7, 8,7, and 7,7.
  For now, only consider horizontal and vertical lines: lines where either x1 = x2 or y1 = y2.

  So, the horizontal and vertical lines from the above list would produce the following diagram:
  ```
  .......1..
  ..1....1..
  ..1....1..
  .......1..
  .112111211
  ..........
  ..........
  ..........
  ..........
  222111....
  ```
  In this diagram, the top left corner is 0,0 and the bottom right corner is 9,9. Each position is shown as the number of lines which cover that point or . if no line covers that point. The top-left pair of 1s, for example, comes from 2,2 -> 2,1; the very bottom row is formed by the overlapping lines 0,9 -> 5,9 and 0,9 -> 2,9.

  To avoid the most dangerous areas, you need to determine the number of points where at least two lines overlap. In the above example, this is anywhere in the diagram with a 2 or larger - a total of 5 points.

  Consider only horizontal and vertical lines.

  ## At how many points do at least two lines overlap?

  """
  def part_01(input) do
    input
    |> format_to_line_segments()
    |> keep_horizontal_and_vertical_lines()
    |> generate_all_wind_points()
    |> count_overlaps()
  end

  defp count_overlaps(points) do
    points
    |> List.flatten()
    |> Enum.frequencies()
    |> Enum.filter(fn {_, duplicates} -> duplicates > 1 end)
    |> Enum.count()
  end

  @doc """
  Unfortunately, considering only horizontal and vertical lines doesn't give you the full picture; you need to also consider diagonal lines.

  Because of the limits of the hydrothermal vent mapping system, the lines in your list will only ever be horizontal, vertical, or a diagonal line at exactly 45 degrees. In other words:

  - An entry like 1,1 -> 3,3 covers points 1,1, 2,2, and 3,3.
  - An entry like 9,7 -> 7,9 covers points 9,7, 8,8, and 7,9.
  Considering all lines from the above example would now produce the following diagram:
  ```
  1.1....11.
  .111...2..
  ..2.1.111.
  ...1.2.2..
  .112313211
  ...1.2....
  ..1...1...
  .1.....1..
  1.......1.
  222111....
  ```
  You still need to determine the number of points where at least two lines overlap. In the above example, this is still anywhere in the diagram with a 2 or larger - now a total of 12 points.

  ## Consider all of the lines. At how many points do at least two lines overlap?
  """
  def part_02(input) do
    input
    |> format_to_line_segments()
    |> keep_horizontal_and_vertical_and_45_degrees_lines()
    |> Enum.map(&generate_all_wind_points/1)
    |> count_overlaps()
  end

  def format_to_line_segments(coordinates) when is_list(coordinates) do
    coordinates
    |> Enum.map(&format_to_line_segments/1)
  end

  def format_to_line_segments(coordinates) do
    [:x1, :y1, :x2, :y2]
    |> Enum.zip(
      coordinates
      |> String.split([",", " -> ", " "], trim: true)
      |> Enum.map(&String.to_integer/1)
    )
  end

  def keep_horizontal_and_vertical_lines(line_segments) do
    line_segments
    |> Enum.filter(fn [x1: x1, y1: y1, x2: x2, y2: y2] -> x1 == x2 or y1 == y2 end)
  end

  def keep_horizontal_and_vertical_and_45_degrees_lines(line_segments) do
    line_segments
    |> Enum.filter(fn [x1: x1, y1: y1, x2: x2, y2: y2] ->
      x1 == x2 or y1 == y2 or abs(y2 - y1) == abs(x1 - x2)
    end)
  end

  def generate_all_wind_points(x1: x1, y1: y1, x2: x2, y2: y2) when x1 == x2 do
    y1..y2
    |> Enum.map(fn y -> {x1, y} end)
  end

  def generate_all_wind_points(x1: x1, y1: y1, x2: x2, y2: y2) when y1 == y2 do
    x1..x2
    |> Enum.map(fn x -> {x, y1} end)
  end

  def generate_all_wind_points(x1: x1, y1: y1, x2: x2, y2: _) when y1 == x2 do
    x1..y1
    |> Enum.zip(x1..y1 |> Enum.reverse())
  end

  def generate_all_wind_points(x1: x1, y1: y1, x2: x2, y2: y2) do
    x1..x2
    |> Enum.zip(y1..y2)
  end

  def generate_all_wind_points(line_segments) when is_list(line_segments) do
    line_segments
    |> Enum.map(&generate_all_wind_points/1)
  end
end
