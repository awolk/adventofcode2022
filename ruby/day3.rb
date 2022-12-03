require_relative './aoc'

def priority(item)
  # Z < a
  if item <= "Z"
    item.ord - "A".ord + 27
  else
    item.ord - "a".ord + 1
  end
end

lines = AOC.get_input(3).split("\n")

pt1 = lines.sum do |line|
  a = line[(line.length/2)...]
  b = line[...(line.length/2)]
  shared = (a.chars & b.chars).first
  priority(shared)
end
puts "Part 1: #{pt1}"


pt2 = lines.each_slice(3).sum do |group|
  shared = group.map(&:chars).reduce(&:&).first
  priority(shared)
end
puts "Part 2: #{pt2}"