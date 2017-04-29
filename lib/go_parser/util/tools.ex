defmodule GoParser.Util.Tools do
  # Receive a charlist, eg.: '[ad]', or '[]'
  # Returns a tuple {x, y}
  def move_to_coordinates(move) when not is_binary(move) do
    move_to_coordinates(move |> to_string)
  end

  def move_to_coordinates(move) do
    sanitize_moves(move)
    |> Enum.map(&move_to_coordinate(&1))
  end
  
  def move_to_coordinate(move) do
    array_of_index = move
    |> to_charlist
    |> Enum.map(& &1 - 97)
    
    {Enum.at(array_of_index, 0), Enum.at(array_of_index, 1)}
  end
  
  def coordinate_to_move(coordinate) do
    [elem(coordinate, 0) + 97, elem(coordinate, 1) + 97]
    |> to_string
  end
  
  def sanitize_moves(move) do
    move
    |> String.split("]")
    |> Enum.map(fn(s) -> String.replace(s, "[", "") end)
    |> Enum.reject(fn(m) -> m == "" end)
  end
end