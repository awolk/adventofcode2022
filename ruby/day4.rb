require_relative './lib/aoc'

pairs = AOC.get_input(4).split.map do |line|
  line.split(',').map do |range|
    a, b = range.split('-').map(&:to_i)
    a..b
  end
end

pt1 = pairs.count do |r1, r2|
  r1.cover?(r2) || r2.cover?(r1)
end
puts "Part 1: #{pt1}"

pt2 = pairs.count do |r1, r2|
  # if there's an overlap then the start of one range will be within the other
  r1.cover?(r2.first) || r2.cover?(r1.first)
end
puts "Part 2: #{pt2}"
