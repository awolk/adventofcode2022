require_relative './lib/aoc'
require_relative './lib/parser'

class Monkey
  attr_reader :inspected, :divisible_test
  # need to be set after all monkeys created
  attr_writer :remainder, :true_target, :false_target

  def initialize(items, operator, divisible_test)
    @initial_items = items.clone
    @items = items
    @operator = operator
    @divisible_test = divisible_test
    @inspected = 0
  end

  def reset
    @items = @initial_items
    @inspected = 0
  end

  def give(item)
    @items.push(item)
  end

  def take_turn(relief_divisor)
    while !@items.empty?
      @inspected += 1
      item = @items.shift
      item = @operator.call(item)
      item /= relief_divisor
      item %= @remainder
      if item % @divisible_test == 0
        @true_target.give(item)
      else
        @false_target.give(item)
      end
    end
  end
end

# Parse
op_parser =
  (P.str('* ') >> P.int).map {|i| i.method(:*)} |
  (P.str('+ ') >> P.int).map {|i| i.method(:+)} |
  P.str('* old').map {lambda {|x| x * x}}
monkey_parser = P.seq(
  "Monkey ", P.int, ":\n",
  "  Starting items: ", P.int.delimited(", "), "\n",
  "  Operation: new = old ", op_parser, "\n",
  "  Test: divisible by ", P.int, "\n",
  "    If true: throw to monkey ", P.int, "\n",
  "    If false: throw to monkey ", P.int
).map do |monkey_num, items, operator, divisible_test, true_target, false_target|
  [Monkey.new(items, operator, divisible_test), true_target, false_target]
end
monkeys_parser = monkey_parser.delimited("\n\n")

res = monkeys_parser.parse_all(AOC.get_input(11))

# Fill in monkeys details
monkeys = res.map(&:first)
remainder = monkeys.map(&:divisible_test).reduce(&:*)
res.each do |monkey, true_target, false_target|
  monkey.true_target = monkeys[true_target]
  monkey.false_target = monkeys[false_target]
  monkey.remainder = remainder
end

# Part 1
20.times do
  monkeys.each {|monkey| monkey.take_turn(3)}
end
monkey_business = monkeys.map(&:inspected).sort.reverse!.take(2).reduce(&:*)
puts "Part 1: #{monkey_business}"

# Part 2
monkeys.each(&:reset)
10000.times do
  monkeys.each {|monkey| monkey.take_turn(1)}
end
monkey_business = monkeys.map(&:inspected).sort.reverse!.take(2).reduce(&:*)
puts "Part 2: #{monkey_business}"