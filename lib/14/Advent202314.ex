defmodule Fourteen do
  def solve_01(filename) do
    {_, content} = File.read(filename)
    grid = content |> String.split("\n") |> Enum.map(&(String.graphemes(&1)))
    # identify final positions of all round rocks.

    final_rock_coords = grid |> Enum.with_index |> Enum.map(fn row ->
      elem(row, 0) |> Enum.with_index |> Enum.map(fn slot ->
        {elem(slot, 0), {elem(slot, 1), elem(row, 1)}}
      end)
    end) |> List.flatten |> Enum.filter(&(elem(&1,0) == "O")) |> Enum.map(&(&1 |> elem(1)))
      |> Enum.map(&(&1 |> final_pos(grid)))

    height = grid |> Enum.count
    final_rock_coords |> Enum.reduce(0, fn x, acc ->
      acc + load(x, height)
    end)
  end

  def final_pos(coord, grid) do
    # how high could this rock roll? either 0, or y(above #) + 1
    stop_y = Enum.reduce_while(elem(coord, 1)..0, elem(coord, 1), fn y, acc ->
      if (Enum.at(grid, y) |> Enum.at(elem(coord, 0)) == "#") do
        {:halt, acc}
      else
        {:cont, y}
      end
    end)

    # how many other round rocks are between this one and stopping point?
    n_rocks = Enum.reduce(elem(coord, 1)..stop_y, -1, fn y, acc ->
      if (Enum.at(grid, y) |> Enum.at(elem(coord, 0)) == "O") do
        acc + 1
      else
        acc
      end
    end)

    {elem(coord, 0), stop_y + n_rocks}
  end

  def load(coord, height) do
    height - elem(coord, 1)
  end

  def solve_02(filename) do
    {_, content} = File.read(filename)
    content
  end
end
