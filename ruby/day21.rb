require 'set'
require_relative './lib/aoc'
require_relative './lib/parser'

module Alg
  Variable = Struct.new(:name)
  Operation = Struct.new(:lhs, :op, :rhs)

  def self.op(a, op, b)
    if a.is_a?(Integer) && b.is_a?(Integer)
      a.public_send(op, b)
    else
      Operation.new(a, op, b)
    end
  end
end

op = P.any(['+', '*', '-', '/']).map(&:to_sym)
expr = P.int | P.seq(P.word, ' ', op, ' ', P.word)
line = P.seq(P.word, ': ', expr)
parser = line.each_line
exprs = parser.parse_all(AOC.get_input(21)).to_h

def calc(name, exprs)
  expr = exprs[name]
  return Alg::Variable.new(name) if expr.nil?
  return expr if expr.is_a?(Integer)
  a, op, b = expr
  Alg.op(calc(a, exprs), op, calc(b, exprs))
end

# given a single variable somewhere in operation, solve for the value of that variable
def solve(operation, value)
  return value if operation.is_a?(Alg::Variable)
  if operation.lhs.is_a?(Integer)
    # when the variable is on the right
    case operation.op
    when :+
      return solve(operation.rhs, value - operation.lhs)
    when :-
      return solve(operation.rhs, operation.lhs - value)
    when :*
      return solve(operation.rhs, value / operation.lhs)
    when :/
      return solve(operation.rhs, operation.lhs / value)
    end
  elsif operation.rhs.is_a?(Integer)
    case operation.op
    when :+
      return solve(operation.lhs, value - operation.rhs)
    when :-
      return solve(operation.lhs, value + operation.rhs)
    when :*
      return solve(operation.lhs, value / operation.rhs)
    when :/
      return solve(operation.lhs, value * operation.rhs)
    end
  else
    raise "unhandled operation structure"
  end
end

# Part 1
pt1 = calc('root', exprs)
puts "Part 1: #{pt1}"

# Part 2
# what value of humn makes the two inputs to root equal
l, _, r = exprs.delete('root')
exprs.delete('humn')
l_eval = calc(l, exprs)
r_eval = calc(r, exprs)
pt2 = if l_eval.is_a?(Integer)
  solve(r_eval, l_eval)
else
  solve(l_eval, r_eval)
end
puts pt2