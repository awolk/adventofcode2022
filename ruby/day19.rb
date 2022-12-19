require 'set'
require_relative './lib/aoc'
require_relative './lib/parser'

State = Struct.new(
  :ore, :clay, :obsidian, :geode,
  :ore_r, :clay_r, :obsidian_r, :geode_r, # number of robots
  :time,
  :ore_b, :clay_b, :obsidian_b # robots blocked (until a different one is built)
) do
  def possible_next(bp)
    can_build_ore = ore >= bp.ore_per_ore_robot && ore_r < bp.max_ore_in_turn
    can_build_clay = ore >= bp.ore_per_clay_robot
    can_build_obsidian = ore >= bp.ore_per_obsidian_robot && clay >= bp.clay_per_obsidian_robot
    can_build_geode = ore >= bp.ore_per_geode_robot && obsidian >= bp.obsidian_per_geode_robot

    if can_build_geode
      # if we can build a geode robot just do it, in practice this works
      return [State.new(
        ore + ore_r - bp.ore_per_geode_robot, clay + clay_r, obsidian + obsidian_r - bp.obsidian_per_geode_robot, geode + geode_r,
        ore_r, clay_r, obsidian_r, geode_r + 1,
        time + 1
      )]
    end

    res = []
    if !can_build_ore || !can_build_clay || !can_build_geode
      # Do nothing, but only if there's something we can't do (and thus might be
      # saving up for). If there's one thing we could build but didn't, then
      # don't build it until we've built something else - otherwise not building
      # it would be wasteful.
      res << State.new(
        ore + ore_r, clay + clay_r, obsidian + obsidian_r, geode + geode_r,
        ore_r, clay_r, obsidian_r, geode_r,
        time + 1,
        can_build_ore, can_build_clay, can_build_obsidian
      )
    end

    if !ore_b && can_build_ore && ore_r < bp.max_ore_in_turn
      res << State.new(
        ore + ore_r - bp.ore_per_ore_robot, clay + clay_r, obsidian + obsidian_r, geode + geode_r,
        ore_r + 1, clay_r, obsidian_r, geode_r,
        time + 1
      )
    end
    if !clay_b && can_build_clay && clay_r < bp.clay_per_obsidian_robot
      res << State.new(
        ore + ore_r - bp.ore_per_clay_robot, clay + clay_r, obsidian + obsidian_r, geode + geode_r,
        ore_r, clay_r + 1, obsidian_r, geode_r,
        time + 1
      )
    end
    if !obsidian_b && can_build_obsidian && obsidian_r < bp.obsidian_per_geode_robot
      res << State.new(
        ore + ore_r - bp.ore_per_obsidian_robot, clay + clay_r - bp.clay_per_obsidian_robot, obsidian + obsidian_r, geode + geode_r,
        ore_r, clay_r, obsidian_r + 1, geode_r,
        time + 1
      )
    end
    res
  end
end

Blueprint = Struct.new(
  :id,
  :ore_per_ore_robot,
  :ore_per_clay_robot,
  :ore_per_obsidian_robot, :clay_per_obsidian_robot,
  :ore_per_geode_robot, :obsidian_per_geode_robot
) do
  def max_ore_in_turn
    @max_ore_in_turn ||=
      [ore_per_clay_robot, ore_per_obsidian_robot, ore_per_geode_robot].max
  end

  def most_geodes(minutes)
    max_geodes = nil
    states = [State.new(0, 0, 0, 0, 1, 0, 0, 0, 0)]
    visited = Set[]
    loop do
      break if states.empty?
      state = states.pop
      next if visited.include?(state)
      visited.add(state)

      if state.time == minutes
        max_geodes = state.geode if max_geodes.nil? || state.geode > max_geodes
      else
        states.concat(state.possible_next(self))
      end
    end
    max_geodes
  end
  
  def quality_level
    mg = most_geodes(24)
    puts "Blueprint #{id} can open #{mg} geodes: #{id * mg} quality level"
    id * mg
  end
end

parser = P.seq(
  "Blueprint ", P.int, ": ",
  "Each ore robot costs ", P.int, " ore. ",
  "Each clay robot costs ", P.int, " ore. ",
  "Each obsidian robot costs ", P.int, " ore and ", P.int, " clay. ",
  "Each geode robot costs ", P.int, " ore and ", P.int, " obsidian."
).map {|ints| Blueprint.new(*ints)}.each_line
blueprints = parser.parse_all(AOC.get_input(19))

pt1 = blueprints.sum(&:quality_level)
puts "Part 1: #{pt1}"

pt2 = blueprints[...3].map do |bp|
  res = bp.most_geodes(32)
  puts "Blueprint #{bp.id} can open #{res} geodes in 32 minutes"
  res
end.reduce(&:*)
puts "Part 2: #{pt2}"