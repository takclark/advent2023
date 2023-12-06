defmodule Three do
  def solve_01(filename) do
    line_str_list = AdventUtils.load_file(filename)
    not_symbols = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]

    # precompute a map of symbol coordinates
    # how do I functional program
    symbol_cords =
      line_str_list
      |> Enum.with_index()
      |> Enum.map(fn row ->
        y = elem(row, 1)

        elem(row, 0)
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reject(&(elem(&1, 0) in not_symbols))
        |> Enum.map(fn char ->
          IO.puts("putting in map at y:#{y}")
          IO.inspect(char)
          {elem(char, 1), y}
        end)
      end)
      |> Enum.reject(&(&1 == []))
      |> List.flatten()
      |> Map.new(&{&1, true})

    IO.inspect(symbol_cords)
  end
end
