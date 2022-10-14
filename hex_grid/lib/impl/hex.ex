defmodule Hexx.Impl.Hex do
  # https://www.redblobgames.com/grids/hexagons/
  defstruct([:q, :r, :s])

  @type t :: %__MODULE__{
          q: integer(),
          r: integer(),
          s: integer()
        }

  def new(q, r, s) when q + r + s != 0 do
    raise("Invalid hex coordinate #{q}, #{r}, #{s} (must meet q + r + s = 0)")
  end

  def new(q, r, s) do
    %__MODULE__{
      q: q,
      r: r,
      s: s
    }
  end

  def new(q, r) do
    # given q + r + s = 0 constraint, s can be calculated
    new(q, r, -q - r)
  end

  defp to_qrs(h) do
    [h.q, h.r, h.s]
  end

  def hex_add(a, b) do
    new(a.q + b.q, a.r + b.r, a.s + b.s)
  end

  def hex_directions do
    # there are 6 directions from a hex, where one value of q, r, s
    # is decreased by one, while another is increased by one
    # these are ordered counterclockwise,
    # starting with "southeast" assuming the north-is-flat-part layout
    # or "east" assuming the north-is-pointy-part layout
    %{
      0 => new(1, 0, -1),
      1 => new(1, -1, 0),
      2 => new(0, -1, 1),
      3 => new(-1, 0, 1),
      4 => new(-1, 1, 0),
      5 => new(0, -1, 1)
    }
  end

  @spec hex_direction(integer()) :: t()
  def hex_direction(direction) do
    hex_directions()[direction]
  end

  def hex_neighbor(hex, direction) do
    hex_add(hex, hex_direction(direction))
  end

  def hex_subtract(a, b) do
    new(a.q - b.q, a.r - b.r, a.s - b.s)
  end

  def hex_distance(a, b) do
    hex_subtract(a, b)
    |> to_qrs()
    |> Enum.map(&abs/1)
    |> Enum.reduce(&max/2)
  end
end
