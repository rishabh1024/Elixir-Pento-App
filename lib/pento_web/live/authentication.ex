defmodule Number do
  # new/1 creates a term of the module's type by taking a String input
  def new(string), do: Integer.parse(string) |> elem(0)
  # add/2 reducer adds to integers as input and returns integer output
  def add(number, addend), do: number + addend
  # to_string/1 converts the term to another type which is String here
  def to_string(number), do: Integer.to_string(number)
end
