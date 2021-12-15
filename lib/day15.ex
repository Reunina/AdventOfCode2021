defmodule Day15 do
  @moduledoc """
  module doc TBD
  """

  require Integer

  def mark_as_visited(points, {x, y} = coord) do
    points
    |> Map.update(coord, {0, true}, fn {e_value, e_visited} -> {e_value, true} end)
  end

  @doc """
  part_01 doc TBD
  """
  def part_01_t2(graph, starting_coord \\ {0, 0}) do
    starting_point =
      {starting_coord,
       graph
       |> Map.get(starting_coord)}

    goal = graph |> Map.keys() |> Enum.max()
    graph = graph |> mark_as_visited(starting_coord)
    res = compute([], graph, starting_point, goal)

    res
    |> Enum.take(2)
    |> IO.inspect(label: " ??2")
    |> Enum.map(fn list -> Enum.sum(list) end)
    |> Enum.min()
    |> IO.inspect(label: " ??2")

    res
    |> Enum.map(fn list -> {Enum.sum(list), list} end)
    |> Enum.min_max()

    # |> print_nice
  end

  defp direct_neig({{x, y}, _}) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
  end

  defp get_lower([]) do
    []
  end

  defp get_lower(graph) do
    graph
    |> Enum.group_by(fn {_, {v, _}} -> v end)
    |> Enum.min()
    |> elem(1)
    |> Map.new()
  end

  def compute(paths, graph, starting_point, goal) do
    {starting_coord, {ref, _}} = starting_point
    graph = graph |> mark_as_visited(starting_coord)

    graph
    |> Enum.filter(fn {coord, _} -> coord in direct_neig(starting_point) end)
    |> Enum.reject(fn {_, {v, visited}} -> visited end)
    |> get_lower()
    |> Enum.flat_map(fn
      {coord, {v, visited}} when coord == goal ->
        [[v | paths]]

      {coord, data} = point ->
        {coord, {v, visited}} = point

        compute(
          [v | paths],
          graph |> mark_as_visited(coord),
          point,
          goal
        )
    end)
  end

  def risk_to(risk_at, start, target) do
    next_to_visit = :pqueue2.in(start, 0, :pqueue2.new())
    risk_to = %{{0, 0} => 0}

    {next_to_visit, risk_to}
    |> Stream.iterate(fn {next_to_visit, risk_to} ->
      step(risk_at, target, next_to_visit, risk_to)
    end)
    |> Enum.find(&is_integer/1)
  end

  def step(risk_at, target, next_to_visit, risk_to) do
    case :pqueue2.out(next_to_visit) do
      {{:value, ^target}, _next_to_visit} ->
        risk_to[target]

      {{:value, {x, y}}, next_to_visit} ->
        [{x + 1, y}, {x, y + 1}, {x - 1, y}, {x, y - 1}]
        |> Enum.filter(fn next -> Map.has_key?(risk_at, next) end)
        |> Enum.reduce({next_to_visit, risk_to}, fn next, {next_to_visit, risk_to} ->
          risk_to_next = risk_to[{x, y}] + risk_at[next]

          if not Map.has_key?(risk_to, next) or risk_to_next < risk_to[next] do
            next_to_visit = :pqueue2.in(next, risk_to_next, next_to_visit)
            risk_to = Map.put(risk_to, next, risk_to_next)
            {next_to_visit, risk_to}
          else
            {next_to_visit, risk_to}
          end
        end)
    end
  end

  def expand(risk_map) do
    {max_x, max_y} = risk_map |> Map.keys() |> Enum.max()

    for {{x, y}, risk} <- risk_map, tile_y <- 0..4, tile_x <- 0..4 do
      x = tile_x * (max_x + 1) + x
      y = tile_y * (max_y + 1) + y
      risk = rem(risk + tile_x + tile_y - 1, 9) + 1
      {{x, y}, risk}
    end
    |> Map.new()
  end

  def part_two(input_file \\ "input.txt") do
    risk_map = input_file |> File.read!() |> parse() |> expand()
    bottom_right = risk_map |> Map.keys() |> Enum.max()
    IO.puts("part_two")
    risk_to(risk_map, {0, 0}, bottom_right)
  end

  def part_01(graph, start \\ {0, 0}) do
    {{max_x, _}, _} = Enum.max_by(graph, fn {{x, _}, _} -> x end)
    {{_, max_y}, _} = Enum.max_by(graph, fn {{_, y}, _} -> y end)
    {{{_, max_y}, _}, {{max_x, _}, _}} = Enum.min_max(graph) |> IO.inspect(label: "KKK")
    goal = {max_x, max_y} |> IO.inspect(label: "KKK")
    graph[start] |> IO.inspect(label: "KKK")
    graph[goal] |> IO.inspect(label: "KKK")
    graph[{38, 2}] |> IO.inspect(label: "KKK))))")

    graph
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(5)
    |> IO.inspect(label: "KKK))))")

    ng =
      graph
      |> Map.update(start, nil, fn {risk_level, _} -> {risk_level, 0} end)
      |> Map.update(goal, nil, fn {risk_level, _} -> {risk_level, 0} end)

    graph
    |> delete(start)
    |> dijkstra(ng, {start, ng[start]}, {{49, 9}, {6, 1000}})
  end

  def dijkstra(_unvisited, _graph, {goal, {_, distance}}, goal),
    do: distance |> IO.inspect(label: "distance")

  def dijkstra(unvisited, graph, {coord, {risk_level, distance}}, goal) do
    neighbors =
      get_neighbors(unvisited, coord)
      |> Enum.map(fn {coord, {v, d}} ->
        {coord, {v, min(distance + v, d)}}
      end)
      |> Map.new()

    updated_nodes = update_distances(graph, neighbors)
    updated_unvisited = update_distances(unvisited, neighbors)

    next =
      if updated_unvisited == %{} do
        goal |> IO.inspect(label: "goal")
        {goal, {risk_level, distance}}
      else
        updated_unvisited
        |> Enum.min_by(fn {{x, y}, {z, t}} -> t end)
      end

    updated_unvisited
    |> delete(coord)
    |> dijkstra(
      updated_unvisited
      |> delete(coord),
      next,
      goal
    )
  end

  def update_distances(graph, neighbors) do
    upd =
      graph
      |> Map.merge(
        neighbors,
        fn _coord, {risk_level, d1}, {_, d2} -> {risk_level, min(d1, d2)} end
      )

    upd
  end

  def get_neighbors(unvisited, {x, y}) do
    unvisited
    |> Enum.filter(fn {{xx, yy}, _} ->
      {xx, yy} in [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    end)
  end

  defp delete(graph, point) do
    graph
    |> Map.delete(point)
  end

  defp find_possible_next_points(points, current_position) do
    {{x, y}, _} = current_position
    nx = {x + 1, y}
    ny = {x, y + 1}

    points
    |> Map.take([nx, ny])
    |> Enum.reject(fn {_, {_, visited}} -> visited end)
  end

  defp find_next_lower_risk_point(points, current_position) do
    {{x, y}, _} = current_position
    nx = {x + 1, y}
    ny = {x, y + 1}

    neigbhors =
      points
      |> Map.take([nx, ny])
      |> Enum.reject(fn {_, {_, visited}} -> visited end)

    lowest =
      if neigbhors == [] do
        current_position
      else
        neigbhors
        |> Enum.max_by(fn {{x, y}, {v, visited}} -> visited end)
      end

    {lowest,
     points
     |> mark_as_visited(current_position)
     |> mark_as_visited(lowest)}
  end

  #   if all_0? do
  #          {:halt, [step, res |> reset_flashed()]}
  #        else
  #          {:cont, [count, res |> reset_flashed()]}
  #        end
  @doc """
  part_02 doc TBD
  """
  def part_02(input) do
    input
    |> part_two
  end

  def combo_by_5(graph) do
    {{max_x, _}, _} = Enum.max_by(graph, fn {{x, _}, _} -> x end)
    {{_, max_y}, _} = Enum.max_by(graph, fn {{_, y}, _} -> y end)

    {max_x, max_y} |> IO.inspect(label: "d {max_x, max_y}e")

    dupl_rows =
      graph
      |> Enum.flat_map(fn {{x, y}, {risk_level, distance}} = current ->
        1..4
        |> Enum.map(fn time ->
          {{x + (max_x + 1) * time, y}, {mod_val(risk_level + time), distance}}
        end)
        |> Enum.concat([current])
      end)
      |> List.flatten()
      |> Map.new()

    dupl_rows
    |> Enum.flat_map(fn {{x, y}, {risk_level, distance}} = current ->
      1..4
      |> Enum.map(fn time ->
        {{x, y + (max_y + 1) * time}, {mod_val(risk_level + time), distance}}
      end)
      |> Enum.concat([current])
    end)
    |> List.flatten()
    |> Map.new()
  end

  defp mod_val(x) when x < 10, do: x

  defp mod_val(x) do
    Integer.mod(x, 9)
  end

  def parse(filename) do
    filename
    |> String.split()
    |> Enum.with_index(fn line, y ->
      line
      |> to_charlist()
      |> Enum.with_index(fn energy, x -> {{x, y}, energy - ?0} end)
    end)
    |> List.flatten()
    |> Map.new()
  end

  def extract_data(filename) do
    filename
    |> FileReader.read_file()
    |> Enum.to_list()
    |> Enum.with_index()
    |> Enum.map(fn {x, y} ->
      {y,
       x
       |> String.split("", trim: true)
       |> Enum.with_index()}
    end)
    |> Enum.map(fn {x, values} ->
      values
      |> Enum.map(fn {v, y} ->
        {
          {x, y},
          {
            String.to_integer(v),
            1_000
          }
        }
      end)
    end)
    |> List.flatten()
    |> Map.new()
  end
end
