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
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  @doc """
  Hash String


  """
  def hash_string(string) do
    hex = :crypto.hash(:md5, string)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end


  @doc """
  Pick Color


  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do

    %Identicon.Image{image | color: {r, g, b}}
  end


  @doc """
  Build Grid


  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid
      = hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end


  @doc """
  Mirror Row

  ## Examples

      iex> Identicon.mirror_row([127, 42, 186])
      [127, 42, 186, 42, 127]

  """
  def mirror_row(row) do
    [first, second, _tail] = row
    row ++ [second, first]
  end


  @doc """
  Filter Odd Squares

  """
  def filter_odd_squares(%Identicon.Image{grid: grid } = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end


  @doc """
  Build Pixel Map

  """
  def build_pixel_map(%Identicon.Image{grid: grid } = image) do
    pixel_map =
      Enum.map grid, fn({_code, index}) ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50

        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end

    %Identicon.Image{image | pixel_map: pixel_map}

  end


  @doc """
  Draw Image

  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map }) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)

  end



    @doc """
    Save Image

    """
    def save_image(image, input) do
      File.write("#{input}.png", image)
    end
end
