require 'set'
require_relative './lib/aoc'

# ordered bottom to top
ROCKS = [
  ["####"],
  [".#.", "###", ".#."],
  ["###", "..#", "..#"],
  ["#", "#", "#", "#"],
  ["##", "##"]
]

class Chamber
  attr_reader :fallen_rocks, :max_height

  def initialize(jets)
    @jets = jets
    @fallen_rocks = 0
    @max_height = 0
    @rows = []
    @rocks_index = 0
    @jets_index = 0
    next_rock
  end

  def next_rock
    @current_rock = ROCKS[@rocks_index]
    @current_rock_pos = [@max_height+3, 2]
    @rocks_index = (@rocks_index + 1) % ROCKS.length
  end

  def next_jet
    val = {"<" => -1, ">" => 1}[@jets[@jets_index]]
    @jets_index = (@jets_index + 1) % @jets.length
    val
  end

  def has_rock(row, col)
    @rows.dig(row, col) || false
  end

  def add_rock(row, col)
    @rows.push(Array.new(7, false)) while @rows.length <= row
    @rows[row][col] = true
  end

  def each_current_rock_pos(&blk)
    r, c = @current_rock_pos
    @current_rock.each_with_index do |row, ri|
      row.chars.each_with_index do |char, ci|
        next if char != '#'
        blk.call(r + ri, c + ci)
      end
    end
  end

  def try_move(dr, dc)
    each_current_rock_pos do |r, c|
      nr = r + dr
      nc = c + dc
      return false if has_rock(nr, nc) | !(0..6).member?(nc) || nr < 0
    end
    r, c = @current_rock_pos
    @current_rock_pos = [r + dr, c + dc]
    true
  end

  def step
    try_move(0, next_jet)
    did_move_down = try_move(-1, 0)
    if !did_move_down
      @fallen_rocks += 1
      each_current_rock_pos do |r, c|
        add_rock(r, c)
        @max_height = r+1 if r >= @max_height
      end
      next_rock
    end
  end

  def place_rock
    current_rocks = fallen_rocks
    step while fallen_rocks == current_rocks
  end

  # represents state in the 2 cyclical inputs
  def state
    [@jets_index, @rocks_index]
  end

  def render
    @rows.reverse.each do |row|
      puts row.map(&{true => '#', false => '.'}).join
    end
  end
end

## Part 1
chamber = Chamber.new(AOC.get_input(17))
2022.times {chamber.place_rock}
puts "Part 1: #{chamber.max_height}"

## Part 2
chamber = Chamber.new(AOC.get_input(17))
# find a cycle
states_seen = Set.new
cycle_rocks = nil
cycle_height = nil
loop do
  if states_seen.add?(chamber.state).nil?
    # found a cycle, do it again
    rocks_start = chamber.fallen_rocks
    height_start = chamber.max_height
    state = chamber.state
    loop do
      chamber.place_rock
      break if chamber.state == state
    end

    cycle_rocks = chamber.fallen_rocks - rocks_start
    cycle_height = chamber.max_height - height_start
    break
  end

  chamber.place_rock
end
# pretend to do as many cycles as we can
cycles_to_pretend = (1000000000000 - chamber.fallen_rocks) / cycle_rocks
height_from_pretend = cycles_to_pretend * cycle_height
# actually simulate the remaining rocks to capture the end portion
remaining_rocks = (1000000000000 - chamber.fallen_rocks) % cycle_rocks
remaining_rocks.times {chamber.place_rock}

pt2 = height_from_pretend + chamber.max_height
puts "Part 2: #{pt2}"