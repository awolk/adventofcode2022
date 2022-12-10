require 'set'
require_relative './lib/aoc'

DIRS = {
  "R" => [1, 0],
  "L" => [-1, 0],
  "U" => [0, 1],
  "D" => [0, -1]
}

steps = AOC.get_input(9).split("\n").flat_map do |line|
  dir, steps = line.split
  Array.new(steps.to_i, DIRS[dir])
end

def solve(steps, num_knots)
  knots = Array.new(num_knots) {[0, 0]}
  tail_positions = Set[[0, 0]]

  steps.each do |dx, dy|
    knots.first[0] += dx
    knots.first[1] += dy

    knots.each_cons(2) do |a, b|
      if (b[0] - a[0]).abs >= 2 || (b[1] - a[1]).abs >= 2
        b[0] += a[0] <=> b[0]
        b[1] += a[1] <=> b[1]
      end
    end
    tail_positions.add(knots.last.clone)
  end

  tail_positions.size
end

puts "Part 1: #{solve(steps, 2)}"
puts "Part 2: #{solve(steps, 10)}"