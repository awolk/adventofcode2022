require_relative './lib/aoc'

def cmp(left, right)
  if left.is_a?(Integer) && right.is_a?(Integer)
    left <=> right
  elsif left.is_a?(Integer)
    cmp([left], right)
  elsif right.is_a?(Integer)
    cmp(left, [right])
  elsif left.empty? && !right.empty?
    -1
  elsif !left.empty? && right.empty?
    1
  elsif left.empty? && right.empty?
    0
  else
    fst = cmp(left.first, right.first)
    return fst if fst != 0
    cmp(left[1..], right[1..])
  end
end

pairs = AOC.get_input(13).split("\n\n").map do |pair_s|
  pair_s.split("\n").map {|s| eval(s)}
end

pt1 = pairs.each_with_index.sum do |(left, right), index|
  if cmp(left, right) <= 0
    index + 1
  else
    0
  end
end
puts "Part 1: #{pt1}"

all = pairs.flat_map(&:itself) + [[[2]], [[6]]]
all.sort! {|a, b| cmp(a, b)}
pt2 = all.index([[2]]).next * all.index([[6]]).next
puts "Part 2: #{pt2}"