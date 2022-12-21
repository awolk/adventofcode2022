require 'set'
require_relative './lib/aoc'
require_relative './lib/parser'

op = P.any(['+', '*', '-', '/']).map(&:to_sym)
expr = P.int | P.seq(P.word, ' ', op, ' ', P.word)
line = P.seq(P.word, ': ', expr)
parser = line.each_line
exprs = parser.parse_all(AOC.get_input(21)).to_h

def calc(name, exprs)
  expr = exprs[name]
  return expr if expr.is_a?(Integer)
  a, op, b = expr
  calc(a, exprs).public_send(op, calc(b, exprs))
end

pt1 = calc('root', exprs)
puts "Part 1: #{pt1}"