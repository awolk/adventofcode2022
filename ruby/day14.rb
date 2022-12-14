require 'set'
require_relative './lib/aoc'
require_relative './lib/parser'
parse_input = P.int.delimited(',').delimited(' -> ').each_line
rocks = parse_input.parse_all(AOC.get_input(14))

rock_positions = Set[]
rocks.each do |pos_seq|
  pos_seq.each_cons(2) do |pair|
    (x1, y1), (x2, y2) = pair.sort
    rock_positions.merge((x1..x2).to_a.product((y1..y2).to_a))
  end
end

# Part 1
positions = rock_positions.clone
max_y = positions.map(&:last).max
sand = 0
x, y = 500, 0
loop do
  if y > max_y
    # we're free falling
    break
  elsif !positions.include?([x, y+1])
    y += 1
  elsif !positions.include?([x-1, y+1])
    x -= 1
    y += 1
  elsif !positions.include?([x+1, y+1])
    x += 1
    y += 1
  else
    # we're at rest, on to the next grain
    positions.add([x, y])
    sand += 1
    x, y = 500, 0
  end
end

puts "Part 1: #{sand}"

# Part 2
positions = rock_positions.clone
max_y = positions.map(&:last).max + 1
sand = 0
x, y = [500, 0]
loop do
  if y == max_y
    # we've landed on the ground
    positions.add([x, y])
    sand += 1
    x, y = 500, 0
  elsif !positions.include?([x, y+1])
    y += 1
  elsif !positions.include?([x-1, y+1])
    x -= 1
    y += 1
  elsif !positions.include?([x+1, y+1])
    x += 1
    y += 1
  else
    # we're at rest, on to the next grain
    positions.add([x, y])
    sand += 1
    x, y = [500, 0]
  end
  break if positions.include?([500, 0])
end

puts "Part 2: #{sand}"