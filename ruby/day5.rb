require_relative './lib/aoc'

## Parse
config_s, steps_s = AOC.get_input(5).split("\n\n")

# we don't need the numbering, so skip the last line of the configuration
orig_stacks = config_s.split("\n")[...-1].map do |line|
  line.chars.each_slice(4).map do |col|
    col = col.join.strip
    if col.empty?
      nil
    else
      col[1]
    end
  end
end.transpose.map(&:compact).map(&:reverse!)

Step = Struct.new(:moves, :a, :b)
steps = steps_s.split("\n").map do |line|
  /move (?<moves>\d+) from (?<a>\d+) to (?<b>\d+)/ =~ line
  Step.new(moves.to_i, a.to_i - 1, b.to_i - 1)
end

## Part 1
stacks = orig_stacks.map(&:clone) # deep copy our stacks
steps.each do |step|
  step.moves.times do
    stacks[step.b].push(stacks[step.a].pop)
  end
end

puts "Part 1: #{stacks.map(&:last).join}"

## Part 2
stacks = orig_stacks
steps.each do |step|
  stacks[step.b].push(*stacks[step.a].pop(step.moves))
end

puts "Part 2: #{stacks.map(&:last).join}"