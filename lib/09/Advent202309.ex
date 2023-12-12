defmodule Nine do
  def solve_01(filename) do
    {_, content} = File.read(filename)
    lists = content |> String.split("\n") |> Enum.map(fn x -> x |> String.split(" ") |> Enum.reject(&(&1 == "")) |> Enum.map(&(&1 |> String.to_integer)) end)
    lists |> Enum.reduce(0, fn x, acc ->
      acc + (x |> Enum.reverse |> extrapolate |> hd)
    end)
  end

  def solve_02(filename) do
    {_, content} = File.read(filename)
    lists = content |> String.split("\n") |> Enum.map(fn x -> x |> String.split(" ") |> Enum.reject(&(&1 == "")) |> Enum.map(&(&1 |> String.to_integer)) end)
    lists |> Enum.reduce(0, fn x, acc ->
      acc + (x |> extrapolate |> hd)
    end)
  end

  def extrapolate([]), do: [0]
  def extrapolate(nums) do
    if Enum.all?(nums, &(&1 == 0)) do
      [0 | nums]
    else
      [hd(nums) + (nums |> diffs |> extrapolate |> hd) | nums]
    end
  end

  def diffs(nums) do
    nums |> Enum.reduce({nil, []}, fn
      x, {nil, acc} ->  {x, acc}
      x, {prev, acc} -> {x, [prev - x | acc]}
      end) |> elem(1) |> Enum.reverse
  end
end
