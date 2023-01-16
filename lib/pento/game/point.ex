defmodule Pento.Game.Point do
  alias Pento.Game.Point

  @attrs [:x, :y]
  @enforce_keys @attrs
  @type t :: %{
          x: integer(),
          y: integer()
        }

  defstruct @attrs

  @spec new(integer(), integer()) :: Point.t()
  def new(x, y) when is_integer(x) and is_integer(y) do
    %Point{x: x, y: y}
  end

  @spec move(Point.t(), Point.t()) :: Point.t()
  def move(%Point{x: x, y: y}, %Point{x: change_x, y: change_y}) do
    new(x + change_x, y + change_y)
  end

  @spec transpose(Point.t()) :: Point.t()
  def transpose(%Point{x: x, y: y}), do: new(x, y)

  @spec flip(Point.t()) :: Point.t()
  def flip(%Point{x: x, y: y}), do: new(x, 6 - y)

  @spec reflect(Point.t()) :: Point.t()
  def reflect(%Point{x: x, y: y}), do: new(6 - x, y)

  @spec rotate(Point.t(), integer()) :: Point.t()
  def rotate(%Point{} = point, 0), do: point
  def rotate(%Point{} = point, 90), do: point |> reflect() |> transpose()
  def rotate(%Point{} = point, 180), do: point |> reflect() |> flip()
  def rotate(%Point{} = point, 270), do: point |> flip() |> transpose()

  @spec center(Point.t()) :: Point.t()
  def center(%Point{} = point), do: move(point, new(-3, -3))

  @spec prepare(Point.t(), integer(), boolean(), Point.t()) :: Point.t()
  def prepare(%Point{} = point, rotation, reflected, location) do
    point
    |> rotate(rotation)
    |> maybe_reflect(reflected)
    |> move(location)
    |> center()
    |> center()
  end

  @spec maybe_reflect(Point.t(), boolean()) :: Point.t()
  defp maybe_reflect(%Point{} = point, true), do: reflect(point)
  defp maybe_reflect(%Point{} = point, false), do: point
end
