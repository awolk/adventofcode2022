require_relative './lib/aoc'

class CRT
  attr_reader :signal_strength

  def initialize
    @x = 1
    @time = 0
    @signal_strength = 0
    @awaiting_cycles = [20, 60, 100, 140, 180, 220]
    @view = []
  end

  def noop
    process_during_cycle
  end

  def addx(val)
    2.times {process_during_cycle}
    @x += val
  end

  def display
    @view.each_slice(40).map(&:join).join("\n")
  end

  private def process_during_cycle
    @time += 1
    if !@awaiting_cycles.empty? && @time >= @awaiting_cycles.first
      @signal_strength += @awaiting_cycles.shift * @x
    end
    @view.push((@x-1..@x+1).cover?((@time - 1) % 40) ? '#' : '.')
  end
end

crt = CRT.new
AOC.get_input(10).split("\n").each do |line|
  instr, val = line.split
  if instr == "noop"
    crt.noop
  else
    crt.addx(val.to_i)
  end
end

puts "Part 1: #{crt.signal_strength}"
puts "Part 2:\n#{crt.display}"