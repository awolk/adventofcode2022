require_relative './lib/aoc'
require 'set'

grid = AOC.char_matrix(AOC.get_input(12))

def adjacent((r, c), grid)
  res = []
  res << [r-1, c] if r > 0
  res << [r+1, c] if r < grid.row_count - 1
  res << [r, c-1] if c > 0
  res << [r, c+1] if c < grid.column_count - 1
  res
end

def find_steps_from(grid, start_pos)
  # BFS
  visited = Set[]
  queue = [start_pos]
  next_queue = []
  steps = 0

  loop do
    queue.each do |pos|
      next if visited.include?(pos)
      visited.add(pos)

      height = grid[*pos].tr('S', 'a')
      return steps if height == 'E'

      adjacent(pos, grid).each do |adj_pos|
        adj_height = grid[*adj_pos].tr('E', 'z')
        next_queue.push(adj_pos) if adj_height.ord <= height.ord + 1
      end
    end

    steps += 1
    queue = next_queue
    next_queue = []
    raise "could not find end" if queue.empty?
  end
end

pt1 = find_steps_from(grid, grid.index("S"))
puts "Part 1: #{pt1}"

# No caching of intermediate results, but it's fast enough
pt2 = grid.each_with_index.filter_map do |val, r, c|
  find_steps_from(grid, [r, c]) rescue nil if val == "a"
end.min
puts "Part 2: #{pt2}"