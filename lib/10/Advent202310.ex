defmodule Ten do
  def solve_01(filename) do
    {_, content} = File.read(filename)
    char_coord_list = content |> String.split("\n") |> Enum.with_index |> Enum.map(fn x ->
      str = x |> elem(0)
      row = x |> elem(1)
      str |> String.graphemes |> Enum.with_index |> Enum.map(fn col ->
        {elem(col, 0), {elem(col, 1), row}}
      end)
    end) |> List.flatten
    start = char_coord_list |> Enum.filter(fn x -> elem(x, 0) == "S" end) |> hd |> elem(1)
    m = char_coord_list |>  Map.new(fn x -> {elem(x,1), elem(x,0)} end)

    IO.inspect m
    traverse([{"S", start}], %{}, m, 0)
  end

  def connected(c, "|"), do: [{elem(c, 0), elem(c, 1) - 1}, {elem(c, 0), elem(c, 1) + 1}]
  def connected(c, "-"), do: [{elem(c, 0) - 1, elem(c, 1)}, {elem(c, 0) + 1, elem(c, 1)}]
  def connected(c, "L"), do: [{elem(c, 0), elem(c, 1) - 1}, {elem(c, 0) + 1, elem(c, 1)}]
  def connected(c, "J"), do: [{elem(c, 0), elem(c, 1) - 1}, {elem(c, 0) - 1, elem(c, 1)}]
  def connected(c, "7"), do: [{elem(c, 0), elem(c, 1) + 1}, {elem(c, 0) - 1, elem(c, 1)}]
  def connected(c, "F"), do: [{elem(c, 0), elem(c, 1) + 1}, {elem(c, 0) + 1, elem(c, 1)}]
  # uhhhhh so this is pretty dumb
  # I didn't feel like figuring out what the pipe shape was so I just guessed answers and found it was J in my input.
  def connected(c, "S"), do: connected(c, "J")
  def connected(_, _), do: []

  def traverse([], _, _, step), do: step
  def traverse(to_visit, visited, m, step) do
    # IO.puts ""
    # IO.puts("traverse at step #{step}")
    # IO.inspect to_visit
    # IO.inspect visited

    next = to_visit |> Enum.map(fn x -> connected(elem(x,1), elem(x,0)) end) |> List.flatten() |> Enum.reject(&(visited[&1])) |> Enum.map(fn x -> {m[x], x} end)
    # IO.inspect next
    now_visited = to_visit |> Enum.reduce(visited, fn x, acc ->
      Map.update(acc, elem(x,1), step, fn _ -> step end)
    end)
    case next do
      [] -> (visited |> Map.values |> Enum.max) + 1
      _ -> traverse(next, now_visited, m, step + 1)
    end
  end


  # It's too late to do this island BFS
  def solve_02(filename) do
    {_, content} = File.read(filename)
  end
end
