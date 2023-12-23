defmodule Beam do
  defstruct [pos: {0, 0}, dir: "R"]
end

defmodule Sixteen do
  def solve_01(filename) do
    {_, content} = File.read(filename)
    content |> String.split("\n") |> Enum.map(&(&1 |> String.graphemes))
  end

  def solve_02(filename) do
    {_, content} = File.read(filename)
    content |> String.split("\n")
  end
end
