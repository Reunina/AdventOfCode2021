defmodule Visualizations.Graphcustom do
  alias Graphvix.Graph

  def run(data, filename) do
    paths =
      data
      |> Enum.map(fn list ->
        Enum.reject(list, fn x -> is_list(x) end)
        |> Enum.concat(["start"])
        |> Enum.reverse()
      end)
      |> Enum.with_index(1)

    graph2 = Graphvix.Graph.new()

    graph2 =
      paths
      |> Enum.reduce(graph2, fn {path, solution_id}, graph ->
        temp(path, graph, solution_id)
      end)

    Graph.write(graph2, filename)
    Graph.compile(graph2, filename)
  end

  def temp(path, graph2, solution_id) do
    {graph2, vertex_ids} =
      path
      |> Enum.uniq()
      |> Enum.reduce(
        {graph2, %{}},
        fn vertex, {graph, vertex_ids} ->
          {graph, vertex_id} =
            if(vertex in ["start", "end"],
              do: Graph.add_vertex(graph, vertex, color: "blue"),
              else: Graph.add_vertex(graph, vertex)
            )

          {graph, vertex_ids |> Map.put(vertex, vertex_id)}
        end
      )

    {graph2, vertex_ids} =
      [path]
      |> Enum.reduce({graph2, vertex_ids}, fn segments, {graph, ids} ->
        segments
        |> Enum.chunk(2, 1)
        |> Enum.reduce({graph, ids}, fn [a, b], {graph, ids} ->
          {graph, edge_id} = Graph.add_edge(graph, Map.get(ids, a), Map.get(ids, b))
          {graph, ids}
        end)
      end)

    {graph2, cluster_id} =
      Graph.add_cluster(graph2, vertex_ids |> Map.values(), label: "solution N°#{solution_id}")

    graph2
  end
end
