require 'matrix'
require 'set'
require_relative './lib/aoc'
require_relative './lib/parser'

def render(positions)
  row_min, row_max = positions.map(&:real).minmax
  col_min, col_max = positions.map(&:imag).minmax
  (row_min..row_max).each do |row|
    row_s = (col_min..col_max).map do |col|
      positions.include?(Complex(row, col)) ? '#' : '.'
    end.join
    puts row_s
  end
end

def adjacent_positions(pos)
  [pos - 1i, pos + 1i, pos - 1 - 1i, pos - 1 + 1i, pos - 1, pos + 1 - 1i, pos + 1 + 1i, pos + 1]
end

def empty_tiles(positions)
  row_min, row_max = positions.map(&:real).minmax
  col_min, col_max = positions.map(&:imag).minmax

  (row_max - row_min + 1) * (col_max - col_min + 1) - positions.size
end

def step(positions, checks)
  proposals = positions.map do |pos|
    adj_pos = adjacent_positions(pos)
    next [pos, pos] if !adj_pos.any? {|adj| positions.include?(adj)}

    delta, _ = checks.find do |delta, to_check|
      to_check.all? do |delta_to_check|
        !positions.include?(pos + delta_to_check)
      end
    end
    delta ||= 0
    [pos + delta, pos]
  end
  proposed_new_position_counts = proposals.map(&:first).tally
  proposals.map do |proposed, current|
    if proposed_new_position_counts[proposed] == 1
      proposed
    else
      current
    end
  end.to_set
end

checks = [
  [-1,  [-1-1i, -1, -1+1i]],
  [+1,  [+1-1i, +1, +1+1i]],
  [-1i, [-1-1i, -1i, 1-1i]],
  [+1i, [-1+1i, +1i, 1+1i]],
]

matrix = AOC.char_matrix(AOC.get_input(23))
elf_positions = matrix.each_with_index.filter_map do |chr, r, c|
  Complex(r, c) if chr == '#'
end.to_set

pt1 = nil
pt2 = nil
(1..).each do |steps|
  new_positions = step(elf_positions, checks)
  checks.rotate!(1)

  pt2 = steps if new_positions == elf_positions
  elf_positions = new_positions
  pt1 = empty_tiles(elf_positions) if steps == 10

  break if !pt1.nil? && !pt2.nil?
end

puts "Part 1: #{pt1}"
puts "Part 2: #{pt2}"