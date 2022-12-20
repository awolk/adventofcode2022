require 'set'
require_relative './lib/aoc'
require_relative './lib/parser'

def mix!(indices, original)
  indices.length.times do |i|
    index = indices.index(i)
    indices.delete_at(index)
    indices.insert((index + original[i]) % indices.length, i)
  end
end

def sum_grove(indices, original)
  original_zero_index = original.index(0)
  zero_index = indices.index(original_zero_index)
  [1000, 2000, 3000].sum do |ind|
    index_into_orig = indices[(zero_index + ind) % indices.length]
    original[index_into_orig]
  end
end

# Part 1
original = P.int.each_line.parse_all(AOC.get_input(20))
indices = (0...original.length).to_a
mix!(indices, original)
pt1 = sum_grove(indices, original)
puts "Part 1: #{pt1}"

# Part 2
pt2_orig = original.map {|i| i * 811589153}
indices = (0...pt2_orig.length).to_a
10.times {mix!(indices, pt2_orig)}
pt2 = sum_grove(indices, pt2_orig)
puts "Part 2: #{pt2}"