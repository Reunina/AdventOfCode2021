defmodule Day12 do
  @moduledoc """
  # --- Passage Pathing ---
  With your submarine's subterranean subsystems subsisting suboptimally, the only way you're getting out of this cave anytime soon is by finding a path yourself. Not just a path - the only way to know if you've found the best path is to find all of them.

  """

  @doc """
  Fortunately, the sensors are still mostly working, and so you build a rough map of the remaining caves (your puzzle input). For example:
  ```
  start-A
  start-b
  A-c
  A-b
  b-d
  A-end
  b-end
  ```
  This is a list of how all of the caves are connected. You start in the cave named start, and your destination is the cave named end. An entry like b-d means that cave b is connected to cave d - that is, you can move between them.

  So, the above cave system looks roughly like this:

  ```
    start
    /   \
  c--A-----b--d
    \   /
     end
  ```
  Your goal is to find the number of distinct paths that start at start, end at end, and don't visit small caves more than once. There are two types of caves: big caves (written in uppercase, like A) and small caves (written in lowercase, like b). It would be a waste of time to visit any small cave more than once, but big caves are large enough that it might be worth visiting them multiple times. So, all paths you find should visit small caves at most once, and can visit big caves any number of times.

  Given these rules, there are 10 paths through this example cave system:

  ```
  start,A,b,A,c,A,end
  start,A,b,A,end
  start,A,b,end
  start,A,c,A,b,A,end
  start,A,c,A,b,end
  start,A,c,A,end
  start,A,end
  start,b,A,c,A,end
  start,b,A,end
  start,b,end
  ```
  (Each line in the above list corresponds to a single path; the caves visited by that path are listed in the order they are visited and separated by commas.)

  Note that in this cave system, cave d is never visited by any path: to do so, cave b would need to be visited twice (once on the way to cave d and a second time when returning from cave d), and since cave b is small, this is not allowed.

  Here is a slightly larger example:

  ```
  dc-end
  HN-start
  start-kj
  dc-start
  dc-HN
  LN-dc
  HN-end
  kj-sa
  kj-HN
  kj-dc
  ```
  The 19 paths through it are as follows:

  ```
  start,HN,dc,HN,end
  start,HN,dc,HN,kj,HN,end
  start,HN,dc,end
  start,HN,dc,kj,HN,end
  start,HN,end
  start,HN,kj,HN,dc,HN,end
  start,HN,kj,HN,dc,end
  start,HN,kj,HN,end
  start,HN,kj,dc,HN,end
  start,HN,kj,dc,end
  start,dc,HN,end
  start,dc,HN,kj,HN,end
  start,dc,end
  start,dc,kj,HN,end
  start,kj,HN,dc,HN,end
  start,kj,HN,dc,end
  start,kj,HN,end
  start,kj,dc,HN,end
  start,kj,dc,end
  ```
  Finally, this even larger example has 226 paths through it:

  ```
  fs-end
  he-DX
  fs-he
  start-DX
  pj-DX
  end-zg
  zg-sl
  zg-pj
  pj-he
  RW-he
  fs-DX
  pj-RW
  zg-RW
  start-pj
  he-WI
  zg-he
  pj-fs
  start-RW
  ```
  ## How many paths through this cave system are there that visit small caves at most once?


  """
  def part_01({paths, graph}, starting_point) do
    compute(paths, graph, starting_point, MapSet.new([starting_point]))
    # |> print_nice
  end

  def compute(paths, graph, starting_point, visited) do
    graph
    |> Map.get(starting_point)
    |> Enum.reject(fn accessible_point -> MapSet.member?(visited, accessible_point) end)
    |> Enum.flat_map(fn
      "end" ->
        [["end" | paths]]

      point ->
        compute(
          [point | paths],
          graph,
          point,
          if(lower_cave?(point), do: MapSet.put(visited, point), else: visited)
        )
    end)
  end

  defp lower_cave?(s), do: s == String.downcase(s)

  defp pretty("end"), do: IO.ANSI.format([:green, "end"])
  defp pretty("start"), do: IO.ANSI.format([:green, "start -> "])
  defp pretty(x), do: "#{x} -> "

  defp print_nice(paths) do
    IO.ANSI.enabled?()

    paths
    |> Enum.map(fn x -> x |> Enum.reject(fn n -> is_list(n) end) end)
    |> Enum.map(fn l ->
      l
      |> Enum.concat(["start"])
      |> Enum.reverse()
      |> Enum.map(&pretty/1)
      |> Enum.join("")
    end)
    |> Enum.join("\n")
    |> IO.puts()

    paths
  end

  @doc """
  After reviewing the available paths, you realize you might have time to visit a single small cave twice. Specifically, big caves can be visited any number of times, a single small cave can be visited at most twice, and the remaining small caves can be visited at most once. However, the caves named start and end can only be visited exactly once each: once you leave the start cave, you may not return to it, and once you reach the end cave, the path must end immediately.

  Now, the 36 possible paths through the first example above are:
  ```
  start,A,b,A,b,A,c,A,end
  start,A,b,A,b,A,end
  start,A,b,A,b,end
  start,A,b,A,c,A,b,A,end
  start,A,b,A,c,A,b,end
  start,A,b,A,c,A,c,A,end
  start,A,b,A,c,A,end
  start,A,b,A,end
  start,A,b,d,b,A,c,A,end
  start,A,b,d,b,A,end
  start,A,b,d,b,end
  start,A,b,end
  start,A,c,A,b,A,b,A,end
  start,A,c,A,b,A,b,end
  start,A,c,A,b,A,c,A,end
  start,A,c,A,b,A,end
  start,A,c,A,b,d,b,A,end
  start,A,c,A,b,d,b,end
  start,A,c,A,b,end
  start,A,c,A,c,A,b,A,end
  start,A,c,A,c,A,b,end
  start,A,c,A,c,A,end
  start,A,c,A,end
  start,A,end
  start,b,A,b,A,c,A,end
  start,b,A,b,A,end
  start,b,A,b,end
  start,b,A,c,A,b,A,end
  start,b,A,c,A,b,end
  start,b,A,c,A,c,A,end
  start,b,A,c,A,end
  start,b,A,end
  start,b,d,b,A,c,A,end
  start,b,d,b,A,end
  start,b,d,b,end
  start,b,end
  ```

  The slightly larger example above now has 103 paths through it, and the even larger example now has 3509 paths through it.

  ## Given these new rules, how many paths through this cave system are there?
  """
  def part_02({paths, graph}, starting_point) do
    compute_p2(paths, graph, starting_point, MapSet.new([starting_point]), MapSet.new([]), false)
    # |> print_nice
  end

  def compute_p2(paths, graph, starting_point, visited, small_caves_visited, exception_made?) do
    graph
    |> Map.get(starting_point)
    |> Enum.filter(fn accessible_point ->
      not MapSet.member?(visited, accessible_point) or
        (not exception_made? and MapSet.member?(small_caves_visited, accessible_point))
    end)
    |> Enum.flat_map(fn
      "end" ->
        [["end" | paths]]

      point ->
        {visited, exception_made?, small_caves_visited} =
          handle_exception(point, exception_made?, visited, small_caves_visited)

        compute_p2(
          [point | paths],
          graph,
          point,
          visited,
          small_caves_visited,
          exception_made?
        )
    end)
  end

  defp handle_exception(point, exception_made?, visited, small_caves_visited)
       when point in ["start", "end"],
       do: {MapSet.put(visited, point), exception_made?, small_caves_visited}

  defp handle_exception(point, true, visited, small_caves_visited) do
    if lower_cave?(point) do
      {MapSet.put(visited, point), true, small_caves_visited}
    else
      {visited, true, small_caves_visited}
    end
  end

  defp handle_exception(point, false, visited, small_caves_visited) do
    if lower_cave?(point) do
      if MapSet.member?(small_caves_visited, point) do
        {MapSet.put(visited, point), true, small_caves_visited}
      else
        {MapSet.put(visited, point), false, MapSet.put(small_caves_visited, point)}
      end
    else
      {visited, false, small_caves_visited}
    end
  end
end
