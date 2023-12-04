require AdventUtils

defmodule Advent202304 do
  def solve_01(filename) do
    AdventUtils.load_file(filename) |> Enum.reduce(0, fn x, acc ->
      acc + score_row(x)
    end)
  end

  def solve_02(filename) do
    # initialize a map with process counts, 1 for all rows to start
    AdventUtils.load_file(filename)
  end

  def score_row(row_str) do
    winners = row_str |> String.split("|") |> hd |> String.split(" ") |> Enum.filter(fn x -> AdventUtils.string_parses(x) end)
    yours = row_str |> String.split("|") |> List.last |> String.split(" ") |> Enum.filter(fn x -> AdventUtils.string_parses(x) end)

    score_pts(winners, yours)
  end

  def score_matches(winning, yours) do
    yours |> Enum.reduce(0, fn x, acc ->
      if x in winning do
          acc + 1
      else
        acc
      end
    end)
  end

  def score_pts(winning, yours) do
    yours |> Enum.reduce(0, fn x, acc ->
      if x in winning do
        case acc do
          0 -> 1
          _ -> acc*2
        end
      else
        acc
      end
    end)
  end
end
