defmodule AdventUtils do
  def string_parses(c) when is_bitstring(c) do
    case Integer.parse(c) do
      :error -> false
      _ -> true
    end
  end

  def load_file(filename) do
    {:ok, content} = File.read(filename)
    content |> String.split("\n")
  end
end
