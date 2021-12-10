
defmodule Day09 do
  @moduledoc """
  # --- Smoke Basin ---
  These caves seem to be lava tubes. Parts are even still volcanically active; small hydrothermal vents release smoke into the caves that slowly settles like rain.
  """

  @doc """
  If you can model how the smoke flows through the caves, you might be able to avoid it and be that much safer. The submarine generates a heightmap of the floor of the nearby caves for you (your puzzle input).

  Smoke flows to the lowest point of the area it's in. For example, consider the following heightmap:
  ```
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
  ```
  Each number corresponds to the height of a particular location, where 9 is the highest and 0 is the lowest a location can be.

  Your first goal is to find the low points - the locations that are lower than any of its adjacent locations. Most locations have four adjacent locations (up, down, left, and right); locations on the edge or corner of the map have three or two adjacent locations, respectively. (Diagonal locations do not count as adjacent.)

  In the above example, there are four low points, all highlighted: two are in the first row (a 1 and a 0), one is in the third row (a 5), and one is in the bottom row (also a 5). All other locations on the heightmap have some lower adjacent location, and so are not low points.

  The risk level of a low point is 1 plus its height. In the above example, the risk levels of the low points are 2, 1, 6, and 6. The sum of the risk levels of all low points in the heightmap is therefore 15.

  Find all of the low points on your heightmap.
  ## What is the sum of the risk levels of all low points on your heightmap?
  """
  def part_01(input) do
    input
    |> map_to_coordinates()
    |> find_low_points()
    |> Enum.map(fn {_, v} -> 1 + v end)
    |> Enum.sum()
  end

  defp map_to_coordinates(input) do
    input
    |> Enum.with_index()
    |> Enum.map(fn {values, x} ->
      values
      |> Enum.with_index()
      |> Enum.map(fn {value, y} -> {{x, y}, value} end)
    end)
    |> List.flatten()
    |> Enum.into(%{})
  end

  defp find_low_points(neighborhood) do
    neighborhood
    |> Enum.filter(fn {{x, y}, v} ->
      {{{x, y}, v}, neighborhood}
      |> select_neighbors()
      |> filter_on_values()
      |> all_bigger?()
    end)
  end

  defp filter_on_values({neighbors, v}), do: {neighbors |> Map.values(), v}

  defp select_neighbors({{{x, y}, v}, neighborhood}) do
    direct_neighbors = [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    {neighborhood |> Map.take(direct_neighbors), v}
  end

  defp all_bigger?({list, v}) do
    list
    |> Enum.all?(&(&1 > v))
  end

  @doc """
  Next, you need to find the largest basins so you know what areas are most important to avoid.

  A basin is all locations that eventually flow downward to a single low point. Therefore, every low point has a basin, although some basins are very small. Locations of height 9 do not count as being in any basin, and all other locations will always be part of exactly one basin.

  The size of a basin is the number of locations within the basin, including the low point. The example above has four basins.

  The top-left basin, size 3:
  ```
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
  ```
  The top-right basin, size 9:
  ```
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
  ```
  The middle basin, size 14:
  ```
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
  ```
  The bottom-right basin, size 9:
  ```
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
  ```
  Find the three largest basins and multiply their sizes together. In the above example, this is 9 * 14 * 9 = 1134.

  ## What do you get if you multiply together the sizes of the three largest basins?

  """
  def part_02(input) do
    neighborhood =
      input
      |> map_to_coordinates()

    low_points =
      neighborhood
      |> find_low_points()

    low_points
    |> Enum.reduce(
      [],
      &(&2
        |> Enum.concat([
          &1
          |> basins(neighborhood)
          |> Enum.into(%{})
          |> Enum.filter(fn {_, v} -> v != 9 end)
        ]))
    )
    |> Enum.map(fn c -> 1 + (c |> Enum.count()) end)
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  defp basins({{x, y}, v}, neighborhood) do
    select_neighbors({{{x, y}, v}, neighborhood})
    |> elem(0)
    |> Enum.filter(fn {_, nv} -> nv > v end)
    |> sub_basins(neighborhood)
  end

  defp sub_basins(current_basins, neighborhood) do
    current_basins
    |> Enum.reduce(current_basins, fn basin, acc ->
      basin
      |> basins(neighborhood)
      |> Enum.concat(acc)
    end)
  end
end
