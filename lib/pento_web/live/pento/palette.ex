defmodule PentoWeb.Pento.Palette do
  use Phoenix.Component

  alias PentoWeb.Pento.{Point, Colors, Canvas, Shape}
  alias Pento.Game.{Point, Pentomino}

  def draw(%{shape_names: shape_names} = assigns) do
    shapes =
      shape_names
      |> Enum.with_index()
      |> Enum.map(&pentomino/1)

    assigns = assign(assigns, shapes: shapes)

    ~H"""
    <div id="palette">
      <Canvas.draw view_box="0 0 500 125">
        <%= for shape <- @shapes do %>
          <Shape.draw
            points={ shape.points }
            fill={ Colors.color(shape.color) }
            name={ shape.name } />
        <% end %>
      </Canvas.draw>
    </div>
    """
  end

  defp pentomino({name, i}) do
    {x, y} = {rem(i, 6) * 4 + 3, div(i, 6) * 5 + 3}

    Pentomino.new(name, 0, false, Point.new(x, y))
    |> Pentomino.to_shape()
  end
end
