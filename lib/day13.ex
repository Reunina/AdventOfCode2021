defmodule Day13 do
  def part_01({coordinates, fold_instructions}) do
    {instructions, remaining_instructions} = fold_instructions |> List.pop_at(0)

    coordinates
    |> fold_by(instructions)
  end

  defp fold_by(coordinates, {"y", val}) do
    coordinates
    |> Enum.reject(fn [x, y] -> x == val end)
    |> Enum.map(fn [x, y] -> [if(x > val, do: val - (x - val), else: x), y] end)
    |> Enum.uniq()
  end

  defp fold_by(coordinates, {"x", val}) do
    coordinates
    |> Enum.map(fn [x, y] -> [y, x] end)
    |> fold_by({"y", val})
    |> Enum.map(fn [y, x] -> [x, y] end)
  end

  def pretty_print(coordinates, message) do
    (message <> "\n") |> IO.puts()

    max_x =
      coordinates
      |> Enum.map(fn [x, _] -> x end)
      |> Enum.max()

    max_y =
      coordinates
      |> Enum.map(fn [_, y] -> y end)
      |> Enum.max()

    coordinates

    aa =
      0..max_x
      |> Enum.map(fn x ->
        0..max_y
        |> Enum.map(fn y ->
          if([x, y] in coordinates,
            do: IO.ANSI.format([:light_magenta_background, "  "]),
            else: "  "
          )
        end)
        |> Enum.join("")
      end)
      |> Enum.join("\n")

    IO.puts("\n" <> aa)
    coordinates
  end

  def part_02({coordinates, fold_instructions}) do
    fold_instructions
    |> Enum.reduce(coordinates, fn instruction, coord ->
      coord
      |> fold_by(instruction)
    end)
  end
end
