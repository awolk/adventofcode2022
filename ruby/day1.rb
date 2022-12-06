require_relative './lib/aoc'

calories_per_elf = AOC.get_input(1).split("\n\n").map do |elf|
  elf.split.sum(&:to_i)
end.sort
pt1 = calories_per_elf.last
puts "Part 1: #{pt1}"

pt2 = calories_per_elf.last(3).sum
puts "Part 2: #{pt2}"