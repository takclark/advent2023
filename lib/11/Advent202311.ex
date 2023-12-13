defmodule Eleven do
  require IEx
  def solve_01(filename) do
    {_, content} = File.read(filename)
    map = content |> String.split("\n")
    map |> galaxy_coords |> expand_coords(col_ndxs_to_expand(map), row_ndxs_to_expand(map), 1) |> distances
  end

  def solve_02(filename) do
    {_, content} = File.read(filename)
    map = content |> String.split("\n")
    map |> galaxy_coords |> expand_coords(col_ndxs_to_expand(map), row_ndxs_to_expand(map), 999999) |> distances
  end

  # distance is simple enough on a grid, we're counting steps and not really "distance"
  def dist(a, b), do: abs(elem(b, 0) - elem(a, 0)) + abs(elem(b, 1) - elem(a, 1))

  def distances([]), do: 0
  def distances([_]), do: 0
  def distances(coord_list) do
    (coord_list |> tl |> Enum.reduce(0, fn x, acc -> acc + dist(hd(coord_list), x) end)) + (coord_list |> tl |> distances)
  end

  def row_ndxs_to_expand(rows) do
    rows |> Enum.with_index |> Enum.reduce([], fn x, acc ->
      if Regex.match?(~r/[^.]/, elem(x, 0)) do acc else [elem(x, 1) | acc] end
    end)
  end

  def col_ndxs_to_expand(rows) do
    gphs = rows |> Enum.map(fn x -> String.graphemes(x) end)
    0..(gphs |> hd |> Enum.count) - 1 |> Enum.filter(fn n ->
      Enum.all?(gphs, fn x ->
        Enum.at(x, n) == "."
      end)
    end)
  end

  def expand_coords(coord_list, cols, rows, offset) do
    coord_list |> Enum.map(fn c ->
      col_offset = cols |> Enum.reduce(0, fn x, acc ->
        if elem(c, 0) > x do acc + offset else acc end
      end)
      row_offset = rows |> Enum.reduce(0, fn y, acc ->
        if elem(c, 1) > y do acc + offset else acc end
      end)

      {elem(c, 0) + col_offset, elem(c, 1) + row_offset}
    end)
  end

  def galaxy_coords(map) do
    map |> Enum.with_index |> Enum.map(fn row ->
      Regex.scan(~r/#/, elem(row, 0), return: :index) |> List.flatten |> Enum.map(fn x -> {elem(x,0), elem(row,1)} end)
    end) |> Enum.reject(&(&1 == [])) |> List.flatten
  end
end
