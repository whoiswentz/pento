defmodule PentoWeb.Pento.Shape do
  use Phoenix.Component

  alias PentoWeb.Pento.Point, as: PointComponent
  alias Pento.Game.Point

  def draw(assigns) do
    ~H"""
    <%= for %Point{x: x, y: y} <- @points do %>
      <PointComponent.draw
        x={x}
        y={y}
        fill={@fill}
        name={@name}
      />
    <% end %>
    """
  end
end
