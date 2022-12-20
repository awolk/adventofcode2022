require 'set'
require_relative './lib/aoc'
require_relative './lib/parser'

def mix(values, order)
  order.each_with_index do |val|
    index = values.index(val)
    values.rotate!(index) # put val first
    values.shift
    values.insert(val[0] % values.length, val)
  end
end

def sum_grove(values)
  zero_index = values.find_index {|int, _| int == 0}
  [1000, 2000, 3000].sum {|ind| values[(zero_index + ind) % values.length][0]}
end

input = P.int.each_line.parse_all(AOC.get_input(20)).each_with_index.to_a

# Part 1
res = input.clone
mix(res, input)
pt1 = sum_grove(res)
puts "Part 1: #{pt1}"

# Part 2
input = input.map {|val, ind| [val * 811589153, ind]}
res = input.clone
10.times {mix(res, input)}
pt2 = sum_grove(res)
puts "Part 2: #{pt2}"