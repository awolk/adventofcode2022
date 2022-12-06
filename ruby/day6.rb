require_relative './lib/aoc'

def solve(input, n)
  input.chars.each_cons(n).find_index do |chars|
    chars.uniq.length == n
  end + n
end

input = AOC.get_input(6)
puts "Part 1: #{solve(input, 4)}"
puts "Part 2: #{solve(input, 14)}"