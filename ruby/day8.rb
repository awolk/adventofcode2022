require_relative './lib/aoc'

grid = AOC.get_input(8).split("\n").map(&:chars).map { _1.map(&:to_i) }
height = grid.length
width = grid[0].length

count = (0...height).sum do |r|
  (0...width).count do |c|
    tree = grid[r][c]
    up = (0...r).none? { grid[_1][c] >= tree }
    down = ((r+1)...height).none? { grid[_1][c] >= tree }
    left = (0...c).none? { grid[r][_1] >= tree }
    right = ((c+1)...width).none? { grid[r][_1] >= tree }
    up || down || left || right
  end
end

puts count

best = (0...height).flat_map do |r|
  (0...width).map do |c|
    tree = grid[r][c]
    up = (r-1).downto(0).find_index { grid[_1][c] >= tree }&.+(1) || r
    down = ((r+1)...height).find_index { grid[_1][c] >= tree }&.+(1) || (height - r - 1)
    left = (c-1).downto(0).find_index { grid[r][_1] >= tree }&.+(1) || c
    right = ((c+1)...width).find_index { grid[r][_1] >= tree }&.+(1) || (width - c - 1)
    
    up * down * left * right
  end
end.max

puts best