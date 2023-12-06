require AdventUtils

defmodule Six do
  def solve_01(filename) do
    line_str_list = AdventUtils.load_file(filename)

    times =
      line_str_list
      |> hd
      |> String.split(":")
      |> List.last()
      |> String.trim()
      |> String.split(" ")
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(fn x ->
        {n, _} = Integer.parse(x)
        n
      end)

    distances =
      line_str_list
      |> List.last()
      |> String.split(":")
      |> List.last()
      |> String.trim()
      |> String.split(" ")
      |> Enum.reject(&(&1 == ""))
      |> Enum.map(fn x ->
        {n, _} = Integer.parse(x)
        n
      end)

    Enum.zip(times, distances)
    |> Enum.reduce(1, fn x, acc ->
      acc * ways_to_beat(x)
    end)
  end

  def ways_to_beat(td) do
    time = elem(td, 0)
    d = elem(td, 1)

    # naive
    possible_holds = 0..time |> Enum.to_list()

    possible_holds
    |> Enum.reduce(0, fn h, acc ->
      if distance(h, time) > d do
        acc + 1
      else
        acc
      end
    end)
  end

  def solve_02(filename) do
    line_str_list = AdventUtils.load_file(filename) |> Enum.reject(&(&1 == ""))

    {time, _} =
      line_str_list |> hd |> String.split(":") |> List.last() |> String.trim() |> Integer.parse()

    {distance, _} =
      line_str_list
      |> List.last()
      |> String.split(":")
      |> List.last()
      |> String.trim()
      |> Integer.parse()

    ways_to_beat({time, distance})
  end

  def distance(hold, time) do
    if hold >= time do
      0
    else
      hold * (time - hold)
    end
  end
end
