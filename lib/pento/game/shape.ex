defmodule Pento.Game.Shape do
  alias Pento.Game.{Point, Shape}

  @attrs [:color, :name, :points]
  @enforce_keys @attrs
  @type t :: %{
          color: atom(),
          name: atom(),
          points: list(Point.t())
        }

  defstruct @attrs

  @spec new(atom(), integer(), boolean(), {integer(), integer()}) :: Shape.t()
  def new(name, rotation, reflected, location) do
    points =
      name
      |> points()
      |> Enum.map(&Point.prepare(&1, rotation, reflected, location))

    %Shape{points: points, color: color(name), name: name}
  end

  @spec color(atom()) :: atom()
  defp color(:i), do: :dark_green
  defp color(:l), do: :green
  defp color(:y), do: :light_green
  defp color(:n), do: :dark_orange
  defp color(:p), do: :orange
  defp color(:w), do: :light_orange
  defp color(:u), do: :dark_gray
  defp color(:v), do: :gray
  defp color(:s), do: :light_gray
  defp color(:f), do: :dark_blue
  defp color(:x), do: :blue
  defp color(:t), do: :light_blue

  @spec points(atom()) :: list(Point.t())
  defp points(:i),
    do: [Point.new(3, 1), Point.new(3, 2), Point.new(3, 3), Point.new(3, 4), Point.new(3, 5)]

  defp points(:l),
    do: [Point.new(3, 1), Point.new(3, 2), Point.new(3, 3), Point.new(3, 4), Point.new(4, 4)]

  defp points(:y),
    do: [Point.new(3, 1), Point.new(2, 2), Point.new(3, 2), Point.new(3, 3), Point.new(3, 4)]

  defp points(:n),
    do: [Point.new(3, 1), Point.new(3, 2), Point.new(3, 3), Point.new(4, 3), Point.new(4, 4)]

  defp points(:p),
    do: [Point.new(3, 2), Point.new(4, 3), Point.new(3, 3), Point.new(4, 2), Point.new(3, 4)]

  defp points(:w),
    do: [Point.new(2, 2), Point.new(2, 3), Point.new(3, 3), Point.new(3, 4), Point.new(4, 4)]

  defp points(:u),
    do: [Point.new(2, 2), Point.new(4, 2), Point.new(2, 3), Point.new(3, 3), Point.new(4, 3)]

  defp points(:v),
    do: [Point.new(2, 2), Point.new(2, 3), Point.new(2, 4), Point.new(3, 4), Point.new(4, 4)]

  defp points(:s),
    do: [Point.new(3, 2), Point.new(4, 2), Point.new(3, 3), Point.new(2, 4), Point.new(3, 4)]

  defp points(:f),
    do: [Point.new(3, 2), Point.new(4, 2), Point.new(2, 3), Point.new(3, 3), Point.new(3, 4)]

  defp points(:x),
    do: [Point.new(3, 2), Point.new(2, 3), Point.new(3, 3), Point.new(4, 3), Point.new(3, 4)]

  defp points(:t),
    do: [Point.new(2, 2), Point.new(3, 2), Point.new(4, 2), Point.new(3, 3), Point.new(3, 4)]
end
