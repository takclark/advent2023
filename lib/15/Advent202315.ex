defmodule Fifteen do
  def solve_01(filename) do
    {_, content} = File.read(filename)
    content |> String.split(",") |> Enum.map(&(hash(&1))) |> Enum.sum()
  end

  def hash(string) do
    string |> String.to_charlist |> Enum.reduce(0, fn x, acc ->
       rem((acc + x) * 17, 256)
    end)
  end


  def solve_02(filename) do
    {_, content} = File.read(filename)
    boxes = (for x <- 0..255, do: x) |> Map.new(fn n -> {n, []} end)
    final_boxes = content |> String.split(",") |> Enum.reduce(boxes, fn x, acc ->
      label = Regex.run(~r/[a-z]+/, x) |> hd
      op = Regex.run(~r/[=,-]/, x) |> hd
      box_n = hash(label)


      row = acc[box_n]
      IO.inspect row, label: "#{x}, #{box_n}"
      new_row = case op do
        "=" ->
          l = Regex.run(~r/\d/, x) |> hd |> String.to_integer
          if Enum.any?(row, &(elem(&1, 0) == label)) do
            row |> Enum.map(fn lens -> if (elem(lens,0) == label) do {label, l} else lens end end)
          else
            row ++ [{label, l}]
          end
        "-" ->
          row |> Enum.reject(&(elem(&1, 0) == label))
      end
      IO.inspect(new_row)
      IO.puts ""

      Map.update!(acc, box_n, fn _ -> new_row end)
    end) |> Enum.filter(&(!Enum.empty?(elem(&1,1))))
    IO.inspect final_boxes

    final_boxes |> Enum.map(fn b ->
        {elem(b,0), elem(b,1) |> Enum.map(&(elem(&1,1)))}
    end) |> Enum.reduce(0, fn x, acc ->
      n = elem(x, 0)
      acc + (elem(x, 1) |> Enum.with_index |>  Enum.reduce(0, fn l, acc_l ->
        acc_l + (elem(l, 0) * (elem(l, 1) + 1) * (n+1))
      end))
    end)
  end
end
