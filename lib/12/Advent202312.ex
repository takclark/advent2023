defmodule Twelve do
  def solve_01(filename) do
    {_, content} = File.read(filename)
    content |> String.split("\n") |> Enum.map(fn x ->
      s = String.split(x, " ")
      {hd(s) |> String.graphemes, List.last(s) |> String.split(",") |> Enum.map(&(String.to_integer(&1)))}
    end)
  end

  def runs([]), do: []
  def runs(row), do: String.split(row) |> Enum.reject(&(&1 == ""))

  def ways([], []), do: 1
  def ways(run_list, target) do
    IO.puts "ways"
    IO.inspect run_list
    IO.inspect target
    # head of run_list starts with a #, we _must_ be fulfilling the first target in head of run_list.
    if hd(run_list) |> String.starts_with?("#") do
      if target == [] do
        0
      else
        ways(
          if (hd(run_list) |> String.length > 1) do
            [hd(run_list) |> String.replace("#", "", global: false) | tl(run_list)]
          else
            tl(run_list)
          end,
          if hd(target) > 1 do
            [hd(target) - 1 | tl(target)]
          else
            tl(target)
          end
        )
      end
    else
      # # we may be fulfilling 0-n targets
      # ways(
      #   [hd(run_list) |> String.replace("?", "", global: false))
    end
  end

  # This problem seems to have optimal substructure.
  def satisfies(row, target) do
    # matching run lengths exactly means any ? should be dots, i.e. there's only a single possibility
    target == Regex.scan(~r/#+/, row, return: :index) |> List.flatten |> Enum.map(&(&1 |> elem(1)))
  end


  def solve_02(filename) do
    {_, content} = File.read(filename)
    content
  end
end
