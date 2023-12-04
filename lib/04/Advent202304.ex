require AdventUtils

defmodule Advent202304 do
  def solve_01(filename) do
    AdventUtils.load_file(filename)
    |> Enum.reduce(0, fn x, acc ->
      acc + score_row(x)
    end)
  end

  def solve_02(filename) do
    AdventUtils.load_file(filename)
    |> Enum.map(fn x ->
      {x, 1, count_matches(x)}
    end)
    |> process
  end

  def process(chart) do
    case chart do
      # base case, we're done
      [] ->
        0

      _ ->
        left_for_this_line = elem(hd(chart), 1)

        case left_for_this_line do
          0 ->
            IO.puts("finished with:")
            IO.puts("#{elem(hd(chart), 0)}")
            IO.puts("next n:")

            unless tl(chart) == [] do
              IO.puts("#{elem(hd(tl(chart)), 1)}")
            end

            process(tl(chart))

          _ ->
            win_count = elem(hd(chart), 2)

            1 +
              process([
                put_elem(hd(chart), 1, left_for_this_line - 1)
                | carry(tl(chart), win_count)
              ])
        end
    end
  end

  @doc """
  Apply a "winning" count n forward through chart, a list of tuples {ticket, number of times to process}
  """
  def carry(chart, n) do
    case chart do
      [] ->
        chart

      _ ->
        if n == 0 do
          chart
        else
          [put_elem(hd(chart), 1, elem(hd(chart), 1) + 1) | carry(tl(chart), n - 1)]
        end
    end
  end

  def count_matches(row_str) do
    winners =
      row_str
      |> String.split("|")
      |> hd
      |> String.split(" ")
      |> Enum.filter(fn x -> AdventUtils.string_parses(x) end)

    yours =
      row_str
      |> String.split("|")
      |> List.last()
      |> String.split(" ")
      |> Enum.filter(fn x -> AdventUtils.string_parses(x) end)

    score_matches(winners, yours)
  end

  def score_row(row_str) do
    winners =
      row_str
      |> String.split("|")
      |> hd
      |> String.split(" ")
      |> Enum.filter(fn x -> AdventUtils.string_parses(x) end)

    yours =
      row_str
      |> String.split("|")
      |> List.last()
      |> String.split(" ")
      |> Enum.filter(fn x -> AdventUtils.string_parses(x) end)

    score_pts(winners, yours)
  end

  def score_matches(winning, yours) do
    yours
    |> Enum.reduce(0, fn x, acc ->
      if x in winning do
        acc + 1
      else
        acc
      end
    end)
  end

  def score_pts(winning, yours) do
    yours
    |> Enum.reduce(0, fn x, acc ->
      if x in winning do
        case acc do
          0 -> 1
          _ -> acc * 2
        end
      else
        acc
      end
    end)
  end
end
