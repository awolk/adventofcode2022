require 'matrix'
require_relative './lib/aoc'
require_relative './lib/parser'

FACING = [
  [0, 1],  # >
  [1, 0],  # v
  [0, -1], # <
  [-1, 0]  # ^
]

class Grid
  attr_reader :pos, :facing
  def initialize(input)
    # pad lines
    lines = input.split("\n")
    max_line_length = lines.map(&:size).max
    lines.map! {|line| line.ljust(max_line_length).chars}

    @matrix = Matrix.rows(lines)
    @pos = @matrix.index('.')
    @facing = 0
  end

  def password
    r, c = @pos
    1000 * (r + 1) + 4 * (c + 1) + @facing
  end

  def rotate_right
    @facing = (@facing + 1) % 4
  end

  def rotate_left
    @facing = (@facing - 1) % 4
  end

  def move(steps)
    dr, dc = FACING[@facing]
    steps.times do
      r, c = @pos

      nr, nc = r + dr, c + dc
      if dc == 0
        bounds = col_bounds(c)
        nr = bounds.begin + ((nr - bounds.begin) % bounds.size)
      else
        bounds = row_bounds(r)
        nc = bounds.begin + ((nc - bounds.begin) % bounds.size)
      end

      return if @matrix[nr, nc] == '#'
      @pos = [nr, nc]
    end
  end

  private def row_bounds(r)
    row = @matrix.row(r).to_a
    row.index {_1 != ' '} .. row.rindex {_1 != ' '}
  end

  private def col_bounds(c)
    col = @matrix.column(c).to_a
    col.index {_1 != ' '} .. col.rindex {_1 != ' '}
  end
end

grid_s, path_s = AOC.get_input(22).split("\n\n")

dir = P.any(['L', 'R'])
path_parser = (P.int & (dir & P.int).repeated).map(&:flatten)

grid = Grid.new(grid_s)
path = path_parser.parse_all(path_s)
path.each do |step|
  case step
  when Integer
    grid.move(step)
  when 'R'
    grid.rotate_right
  when 'L'
    grid.rotate_left
  end
end
puts "Part 1: #{grid.password}"
