defmodule Identicon do
  @moduledoc """
  Documentation for Identicon.
  """

  @doc """
  Main function for Identicon program

  ## Examples

      iex> Identicon.main('testing123')
      [127, 42, 186]

  """
  def main(input) do
    input
    |> hash_string
    |> pick_color
  end

  @doc """
  Hash String

  ## Examples

      iex> Identicon.hash_string('testing123')
      [127, 42, 186, 186, 66, 48, 97, 197, 9, 244, 146, 61, 208, 75, 108, 241]

  """
  def hash_string(string) do
    hex = :crypto.hash(:md5, string)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end


  @doc """
  Pick Color

  ## Examples

      iex> Identicon.pick_color()


  """
  def pick_color(image) do
    %Identicon.Image{hex: hex_list} = image
    [r, g, b | _tail] = hex_list

    [r, g, b]
  end
end
