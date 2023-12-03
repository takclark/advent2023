require IEx

defmodule Advent202302 do
  def load_file(filename) do
    {:ok, content} = File.read(filename)
    content |> String.split("\n")
  end

  def solve_01(filename) do
    games = load_file(filename)

    IO.puts(
      Enum.reduce(games, 0, fn x, acc ->
        acc + validate_game(x)
      end)
    )
  end

  def solve_02(filename) do
    games = load_file(filename)

    Enum.reduce(games, 0, fn x, acc ->
      game_power = x |> get_min_set_for_game |> power
      acc + game_power
    end)
  end

  def power(cube_map) do
    Enum.reduce(cube_map, 1, fn x, acc ->
      acc * elem(x, 1)
    end)
  end

  def get_min_set_for_game(line_str) do
    rounds = line_str |> String.split(":") |> List.last() |> String.split(";")
    parsed_rounds = for x <- rounds, do: parse_round(x)
    # we want max of each across rounds
    Enum.reduce(parsed_rounds, %{}, fn x, acc ->
      acc =
        Enum.reduce(x, acc, fn y, acc_y ->
          Map.update(acc_y, elem(y, 0), elem(y, 1), fn e ->
            if elem(y, 1) > e do
              elem(y, 1)
            else
              e
            end
          end)
        end)

      acc
    end)
  end

  def validate_game(line_str) when is_bitstring(line_str) do
    base = %{red: 12, green: 13, blue: 14}
    # Sample string:
    # Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
    #
    # first pull out the game ID
    {id, _} =
      line_str |> String.split(":") |> hd |> String.split(" ") |> List.last() |> Integer.parse()

    # there may be multiple rounds, parse them into maps
    rounds = line_str |> String.split(":") |> List.last() |> String.split(";")
    # See if all rounds are possible
    possible =
      rounds
      |> Enum.all?(fn x ->
        x |> parse_round |> round_is_possible?(base)
      end)

    # Return 0 if the game is possible. Return the ID otherwise.
    result =
      if possible do
        id
      else
        0
      end

    result
  end

  def parse_round(round_str) do
    # ex: " 1 red, 2 green, 6 blue"
    colors = round_str |> String.split(",")
    r = ~r/(\d+)\s+([a-z]+)/

    colors
    |> Enum.map(fn x ->
      # from capture groups we should have three matches, whole string followed by e.g. "1", "red"
      match = Regex.run(r, x)
      {count, _} = match |> tl |> hd |> Integer.parse()
      color = match |> tl |> List.last()
      [color, count]
    end)
    |> Map.new(fn l -> {String.to_atom(hd(l)), List.last(l)} end)
  end

  def round_is_possible?(drawn, base) do
    drawn
    |> Enum.all?(fn x ->
      result = base[elem(x, 0)]

      cond do
        result == nil -> false
        result < elem(x, 1) -> false
        true -> true
      end
    end)
  end
end
