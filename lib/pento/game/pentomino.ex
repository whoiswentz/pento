defmodule Pento.Game.Pentomino do
  alias Pento.Game.{Pentomino, Point, Shape}

  @names [:i, :l, :y, :n, :p, :w, :u, :v, :s, :f, :x, :t]
  @default_location Point.new(8, 8)

  @attrs [:name, :rotation, :reflected, :location]
  @enforce_keys @attrs

  @type t :: %{
          name: atom(),
          rotation: integer(),
          reflected: boolean(),
          location: Point.t()
        }

  defstruct @attrs

  @spec new(atom(), integer(), boolean(), {integer(), integer()}) :: Shape.t()
  def new(name \\ :i, rotation \\ 0, reflected \\ false, location \\ @default_location) do
    %Pentomino{
      name: name,
      rotation: rotation,
      reflected: reflected,
      location: location
    }
  end

  @spec rotate(Pentomino.t()) :: Pentomino.t()
  def rotate(%Pentomino{rotation: rotation} = pentomino) do
    %Pentomino{pentomino | rotation: rem(rotation + 90, 360)}
  end

  @spec flip(Pentomino.t()) :: Pentomino.t()
  def flip(%Pentomino{reflected: reflected} = pentomino) do
    %Pentomino{pentomino | reflected: not reflected}
  end

  @spec up(Pentomino.t()) :: Pentomino.t()
  def up(%Pentomino{location: location} = pentomino) do
    %Pentomino{pentomino | location: Point.move(location, Point.new(0, -1))}
  end

  @spec down(Pentomino.t()) :: Pentomino.t()
  def down(%Pentomino{location: location} = pentomino) do
    %Pentomino{pentomino | location: Point.move(location, Point.new(0, 1))}
  end

  @spec left(Pentomino.t()) :: Pentomino.t()
  def left(%Pentomino{location: location} = pentomino) do
    %Pentomino{pentomino | location: Point.move(location, Point.new(-1, 0))}
  end

  @spec right(Pentomino.t()) :: Pentomino.t()
  def right(%Pentomino{location: location} = pentomino) do
    %Pentomino{pentomino | location: Point.move(location, Point.new(1, 0))}
  end

  def to_shape(%Pentomino{
        name: name,
        rotation: rotation,
        location: location,
        reflected: reflected
      }) do
    Shape.new(name, rotation, reflected, location)
  end
end
