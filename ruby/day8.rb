require_relative './lib/aoc'

grid = AOC.digit_matrix(AOC.get_input(8))
height = grid.row_count
width = grid.column_count

visible_trees = grid.each_with_index.count do |tree, r, c|
  row = grid.row(r)
  col = grid.column(c)

  up = col[...r].none? {_1 >= tree}
  down = col[r+1..].none? { _1 >= tree }
  left = row[...c].none? { _1 >= tree }
  right = row[c+1..].none? { _1 >= tree }
  up || down || left || right
end
puts "Part 1: #{visible_trees}"

best_score = grid.each_with_index.map do |tree, r, c|
  row = grid.row(r)
  col = grid.column(c)

  up = col[...r].reverse.index { _1 >= tree }&.next || r
  down = col[r+1..].index { _1 >= tree }&.next || (height - r - 1)
  left = row[...c].reverse.index { _1 >= tree }&.next || c
  right = row[c+1..].index { _1 >= tree }&.next || (width - c - 1)
  
  up * down * left * right
end.max
puts "Part 2: #{best_score}"