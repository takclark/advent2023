require AdventUtils

defmodule Five do
  def solve_01(filename) do
    file = AdventUtils.load_file(filename)
    mappings = file |> parse_mappings()

    file
    |> seed_int_list
    |> Enum.map(fn loc ->
      Enum.reduce(mappings, loc, fn x, acc ->
        transform(acc, x)
      end)
    end)
    |> Enum.min()
  end

  def solve_02(filename) do
    file = AdventUtils.load_file(filename)
    mappings = file |> parse_mappings()
    # get initial seed locations
    seeds = seed_int_list(file)
    # slight modification: transform seed list
    all_seeds =
      seeds
      |> Enum.chunk_every(2)
      |> Enum.map(fn x ->
        build_seed_range(x)
      end)
      |> List.flatten()

    # 1.7 B inputs, why not
    all_seeds
    |> Enum.map(fn loc ->
      Enum.reduce(mappings, loc, fn x, acc ->
        transform(acc, x)
      end)
    end)
    |> Enum.min()
  end

  def build_seed_range(p) do
    Enum.to_list(hd(p)..(hd(p) + List.last(p) - 1))
  end

  def seed_int_list(line_str_list) do
    line_str_list
    |> hd
    |> String.split(":")
    |> List.last()
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(fn x ->
      {n, _} = Integer.parse(x)
      n
    end)
  end

  def parse_mappings(line_str_list) do
    # mappings start on line 2
    mapping_rules =
      line_str_list
      |> tl
      |> tl
      |> Enum.chunk_by(fn x -> x != "" end)
      |> Enum.reject(fn x -> x == [""] end)
      |> Enum.map(fn x -> parse_rule(tl(x)) end)

    mapping_rules
  end

  @doc """
  Parse rule from a string list excluding header
  example:
  ["60 56 37", "56 93 4"]
  """
  def parse_rule(ranges_str_list) do
    ranges_str_list
    |> Enum.map(fn x ->
      x
      |> String.split(" ")
      |> Enum.map(fn x ->
        {n, _} = Integer.parse(x)
        n
      end)
      |> List.to_tuple()
    end)
  end

  def transform(n, range_list) do
    case range_list do
      # nothing to do, return value
      [] ->
        n

      # see if hd transform is relevant
      _ ->
        src = elem(hd(range_list), 1)
        dst = elem(hd(range_list), 0)
        len = elem(hd(range_list), 2)

        if n < src + len && n >= src do
          # IO.puts "matched n:#{n} to src:#{src}, dst:#{dst} with len:#{len}"
          dst + (n - src)
        else
          # try next if not
          n |> transform(tl(range_list))
        end
    end
  end
end
