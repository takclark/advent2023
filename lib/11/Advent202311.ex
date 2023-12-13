defmodule Eleven do
  def solve_01(filename) do
    {_, content} = File.read(filename)
    map = content |> String.split("\n") |> expand
    map |> galaxy_coords |> distances
  end

  def distances([]), do: 0
  def distances([_]), do: 0
  def distances(coord_list) do
    (coord_list |> tl |> Enum.reduce(0, fn x, acc -> acc + dist(hd(coord_list), x) end)) + (coord_list |> tl |> distances)
  end

  def expand(rows) do
    rows |> expand_rows |> expand_cols
  end

  # row dimension: succicnt, elegant
  @spec expand_rows(any()) :: list()
  def expand_rows(rows) do
    rows |> Enum.map(fn x -> if Regex.match?(~r/[^.]/, x) do x else [x, x] end end) |> List.flatten
  end

  # col dimension: you fool, you utter baffoon, good day to be an electric company
  def expand_cols(rows) do
    gphs = rows |> Enum.map(fn x -> String.graphemes(x) end)
    cols_to_expand = 0..(gphs |> hd |> Enum.count) - 1 |> Enum.filter(fn n ->
      Enum.all?(gphs, fn x ->
        Enum.at(x, n) == "."
      end)
    end)

    gphs |> Enum.map(fn x ->
      x |> Enum.with_index |> Enum.map(fn c ->
        if elem(c, 1) in cols_to_expand do
          [elem(c, 0), elem(c, 0)]
        else
          elem(c, 0)
        end
      end) |> List.flatten
      |> Enum.join("") # convert back to string row to match input format of expand?
    end)
  end

  def galaxy_coords(map) do
    map |> Enum.with_index |> Enum.map(fn row ->
      Regex.scan(~r/#/, elem(row, 0), return: :index) |> List.flatten |> Enum.map(fn x -> {elem(x,0), elem(row,1)} end)
    end) |> Enum.reject(&(&1 == [])) |> List.flatten
  end


  # distance is simple enough on a grid, we're counting steps and not really "distance"
  def dist(a, b), do: abs(elem(b, 0) - elem(a, 0)) + abs(elem(b, 1) - elem(a, 1))

  def solve_02(filename) do
    {_, content} = File.read(filename)
    content
  end
end
