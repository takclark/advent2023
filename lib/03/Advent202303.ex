defmodule Three do
  require IEx
  def solve_01(filename) do
    line_str_list = AdventUtils.load_file(filename)
    not_symbols = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]

    # precompute a map of symbol coordinates
    # how do I functional program
    symbol_cord_map =
      line_str_list
      |> Enum.with_index()
      |> Enum.map(fn row ->
        y = elem(row, 1)

        elem(row, 0)
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reject(&(elem(&1, 0) in not_symbols))
        |> Enum.map(fn char ->
          {elem(char, 1), y}
        end)
      end)
      |> Enum.reject(&(&1 == []))
      |> List.flatten()
      |> Map.new(&{&1, true})

    intermediate =
      line_str_list
      |> Enum.with_index()
      |> Enum.map(fn line ->
        get_ints_with_coords_with_y(elem(line, 0), elem(line, 1))
      end)
      |> Enum.reject(&(&1 == []))
      |> List.flatten()

    #  int,   x len  y
    # {467, {{0, 3}, 0}},
    # {114, {{5, 3}, 0}},

    IO.inspect(intermediate)

    intermediate
    |> Enum.reduce(0, fn num, acc ->
      n = elem(num, 0)

      to_check =
        get_adjacent_coords(elem(elem(num, 1), 0), elem(elem(num, 1), 1))
        |> Enum.map(fn x ->
          symbol_cord_map[x]
        end)

      if Enum.any?(to_check) do
        n + acc
      else
        acc
      end
    end)
  end

  def solve_02(filename) do
    line_str_list = AdventUtils.load_file(filename)

    star_coords =
      line_str_list
      |> Enum.with_index()
      |> Enum.map(fn row ->
        y = elem(row, 1)

        elem(row, 0)
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reject(&(elem(&1, 0) != "*"))
        |> Enum.map(fn char ->
          {elem(char, 1), y}
        end)
      end)
      |> Enum.reject(&(&1 == []))
      |> List.flatten()

    numbers =
      line_str_list
      |> Enum.with_index()
      |> Enum.map(fn line ->
        get_ints_with_coords_with_y(elem(line, 0), elem(line, 1))
      end)
      |> Enum.reject(&(&1 == []))
      |> List.flatten()

    star_coords |> Enum.reduce(0, fn sc, acc ->
      numbers_adj = numbers |> Enum.filter(fn num ->
        is_adjacent(sc, elem(num,1))
      end)

      if (numbers_adj |> Enum.count()) == 2 do
        # real
        acc + (elem(hd(numbers_adj),0) * elem(List.last(numbers_adj), 0))
      else
        acc
      end

    end)
  end

  def is_adjacent(cord, x_range_y) do
    # {1,3} , {{0,3}, 0}
    tgt_x_rng_str = elem(elem(x_range_y, 0), 0)
    tgt_x_rng_len = elem(elem(x_range_y, 0), 1)
    tgt_y = elem(x_range_y, 1)

    tst_x = elem(cord, 0)
    tst_y = elem(cord, 1)

    (tst_x >= tgt_x_rng_str-1 && tst_x <= tgt_x_rng_str + tgt_x_rng_len) &&
    (tst_y >= tgt_y-1 && tst_y <= tgt_y + 1)
  end

  def get_ints_with_coords_with_y(line_str, y) do
    # Maybe there's a better way to get matches and indicies?
    r = ~r/\d+/

    Enum.zip(
      Regex.scan(r, line_str) |> List.flatten() |> AdventUtils.parse_ints(),
      Regex.scan(r, line_str, return: :index)
      |> List.flatten()
      |> Enum.map(fn scan_idx ->
        {scan_idx, y}
      end)
    )
  end

  @doc """
  Given a start x and length, and y pos, get all coords {x,y} such that {x,y} is adjacent to the string at x.

  ## Parameters

    - x: Tuple of {start_pos, len}
    - y: Y position

  ## Examples

  iex> Three.get_adjacent_coords({1, 2}, 1)
  [{},{}]
  """
  def get_adjacent_coords(x, y) do
    start_x = elem(x, 0)
    max_x = start_x + elem(x, 1)

    (start_x - 1)..max_x
    |> Enum.to_list()
    |> Enum.map(fn x_pos ->
      (y - 1)..(y + 1)
      |> Enum.to_list()
      |> Enum.map(fn y_pos ->
        {x_pos, y_pos}
      end)
    end)
    |> List.flatten()
  end
end
