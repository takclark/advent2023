defmodule Seven do
  require IEx
  def solve_01(filename) do
    # skipping advent utils so solutions are fully self-contained
    File.read(filename) |> elem(1) |> String.split("\n") |> Enum.map(fn x ->
      split = String.split(x, " ")
      {string_hand_to_int_list(hd(split)), String.to_integer(List.last(split))}
    end)
    |> Enum.sort_by(fn x -> List.last(elem(x,0)) end)
    |> Enum.sort_by(fn x -> Enum.at(elem(x,0), 3) end)
    |> Enum.sort_by(fn x -> Enum.at(elem(x,0), 2) end)
    |> Enum.sort_by(fn x -> Enum.at(elem(x,0), 1) end)
    |> Enum.sort_by(fn x -> hd(elem(x,0)) end)
    |> Enum.sort_by(fn x -> type(elem(x,0)) end)
    |> Enum.map(fn x -> elem(x, 1) end)
    |> Enum.with_index() |> Enum.reduce(0, fn x, acc ->
      acc + elem(x, 0)*(elem(x, 1) + 1)
    end)
  end

  def solve_02(filename) do
    # skipping advent utils so solutions are fully self-contained
    File.read(filename) |> elem(1) |> String.split("\n") |> Enum.map(fn x ->
      split = String.split(x, " ")
      {string_hand_to_int_list_with_jokers(hd(split)), String.to_integer(List.last(split))}
    end)
    |> Enum.sort_by(fn x -> List.last(elem(x,0)) end)
    |> Enum.sort_by(fn x -> Enum.at(elem(x,0), 3) end)
    |> Enum.sort_by(fn x -> Enum.at(elem(x,0), 2) end)
    |> Enum.sort_by(fn x -> Enum.at(elem(x,0), 1) end)
    |> Enum.sort_by(fn x -> hd(elem(x,0)) end)
    |> Enum.sort_by(fn x -> elem(x,0) |> convert_jokers |> type end)
    |> Enum.map(fn x ->
      IO.inspect x
      elem(x, 1)
    end)
    |> Enum.with_index() |> Enum.reduce(0, fn x, acc ->
      acc + elem(x, 0)*(elem(x, 1) + 1)
    end)
  end


  def string_hand_to_int_list(hand) do
    hand
    |> String.graphemes()
    |> Enum.map(fn x ->
      case x do
        "2" -> 0
        "3" -> 1
        "4" -> 2
        "5" -> 3
        "6" -> 4
        "7" -> 5
        "8" -> 6
        "9" -> 7
        "T" -> 8
        "J" -> 9
        "Q" -> 10
        "K" -> 11
        "A" -> 12
        _ -> -1
      end
    end)
  end

  def string_hand_to_int_list_with_jokers(hand) do
    hand
    |> String.graphemes()
    |> Enum.map(fn x ->
      case x do
        "J" -> 0
        "2" -> 1
        "3" -> 2
        "4" -> 3
        "5" -> 4
        "6" -> 5
        "7" -> 6
        "8" -> 7
        "9" -> 8
        "T" -> 9
        "Q" -> 10
        "K" -> 11
        "A" -> 12
        _ -> -1
      end
    end)
  end


  def type(hand) do
    counts = hand |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end) |> Enum.map(&elem(&1, 1)) |> Enum.sort(:desc)

    # Return a numerical assignment of the hand from highest to lowest value.
    case hd(counts) do
      # 5 oak
      5 ->
        6

      # 4 oak
      4 ->
        5

      3 ->
        if List.last(counts) == 2 do
          # full house
          4
        else
          # 3 oak
          3
        end

      2 ->
        if hd(tl(counts)) == 2 do
          # 2 pair
          2
        else
          # par
          1
        end

      # high card
      _ ->
        0
    end
  end

  def convert_jokers(hand) do
    # The optimal thing to do is always convert jokers to the other card of which we have the most.
    # Because rank of the cards doesn't matter, whichever one comes first is fine in event of a tie.
    non_j = hand |> Enum.reject(&(&1 == 0))
    j_count = hand |> Enum.filter(&(&1 == 0)) |> Enum.count()
    if Enum.empty?(non_j) do
      for _ <- 0..4, do: 12
    else
      target = non_j |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end) |> Enum.max_by(fn x -> elem(x,1) end) |> elem(0)
      converted = for i <- 0..j_count, i > 0, do: target
      [non_j | converted] |> List.flatten()
    end

  end
end
