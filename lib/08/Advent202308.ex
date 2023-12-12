defmodule Eight do
  def solve_01(filename) do
    # map will be a map of string to {left, right} string.
    {_, content} = File.read(filename)
    lines = String.split(content, "\n") |> Enum.reject(&(&1 == ""))
    instruction_list = hd(lines) |> String.graphemes() |> Enum.map(fn x -> if x == "L" do 0 else 1 end end)
    instruction_tuple = instruction_list |> List.to_tuple
    instruction_count = instruction_list |> Enum.count
    m = parse_map(tl(lines))
    traverse(instruction_tuple, "AAA", 0, m, instruction_count)
  end

  def solve_02_lcm(filename) do
    {_, content} = File.read(filename)
    lines = String.split(content, "\n") |> Enum.reject(&(&1 == ""))
    instruction_list = hd(lines) |> String.graphemes() |> Enum.map(fn x -> if x == "L" do 0 else 1 end end)
    instruction_tuple = instruction_list |> List.to_tuple
    instruction_count = instruction_list |> Enum.count
    m = parse_map(tl(lines))
    starting_positions = m |> Map.keys |> Enum.filter(&(String.ends_with?(&1, "A")))
    # for each starting position, find the shortest path to a position ending in Z. The total will be the LCM of those.
    starting_positions |> Enum.map(fn x ->
     steps_to_elem(instruction_tuple, x, 0, m, instruction_count)
    end)

    # cheating and just putting these in an lcm calculator. I will return.
  end

  # could refactor this into traverse with matcher func
  def steps_to_elem(instruction, pos, step, m, count) do
    if String.ends_with?(pos, "Z") do
      step
    else
      steps_to_elem(instruction, m[pos] |> elem(elem(instruction, rem(step, count))), step+1, m, count)
    end
  end

  def parse_map(map_lines) do
    map_lines |> Enum.map(&(parse_map_line(&1))) |> Enum.reduce(%{}, fn x, acc ->
      Map.update(acc, elem(x,0), elem(x,1), fn _ -> elem(x,1) end)
    end)
  end

  def traverse(instruction, pos, step, m, count) do
    if pos == "ZZZ" do
      step
    else
      traverse(instruction, m[pos] |> elem(elem(instruction, rem(step, count))), step+1, m, count)
    end
  end

  # ignored numerical keys as they weren't on the input though were on test3, I just replaced those with letters.
  def parse_map_line(line) do
    location = Regex.scan(~r/([A-Z]{3}).*([A-Z]{3}).*([A-Z]{3})/, line) |> List.flatten |> tl
    {hd(location), {hd(tl(location)), List.last(location)}}
  end
end
