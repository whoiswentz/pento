defmodule PentoWeb.Pento.Board do
  use PentoWeb, :live_component

  alias PentoWeb.Pento.{Canvas, Palette, Shape, Colors}
  alias Pento.Game.{Pentomino, Point, Board}

  def update(%{puzzle: puzzle, id: id}, socket) do
    {:ok,
     socket
     |> assign_params(id, puzzle)
     |> assign_board()
     |> assign_shapes()}
  end

  defp assign_params(socket, id, puzzle) do
    assign(socket, id: id, puzzle: puzzle)
  end

  defp assign_board(%{assigns: %{puzzle: puzzle}} = socket) do
    active = Pentomino.new(:p, 0, false, Point.new(3, 2))

    completed = [
      Pentomino.new(:u, 270, false, Point.new(1, 2)),
      Pentomino.new(:v, 90, false, Point.new(4, 2))
    ]

    board =
      puzzle
      |> Board.new()
      |> Map.put(:completed_pentos, completed)
      |> Map.put(:active_pento, active)

    assign(socket, board: board)
  end

  def assign_shapes(%{assigns: %{board: board}} = socket) do
    shape = Board.to_shape(board)
    assign(socket, shapes: [shape])
  end

  def render(assigns) do
    ~H"""
    <div id={@id} phx-window-keydown="key" phx-target={ @myself }>
      <Canvas.draw view_box="0 0 200 70">
        <%= for shape <- @shapes do %>
          <h1><%= shape.color %></h1>
          <Shape.draw
            points={shape.points}
            fill={Colors.color(shape.color, Board.active?(@board, shape.name))}
            name={shape.name} />
        <% end %>
      </Canvas.draw>
      <hr/>
      <Palette.draw shape_names= { @board.palette } id="palette" />
    </div>
    """
  end
end
