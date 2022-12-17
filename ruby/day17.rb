require 'set'
require_relative './lib/aoc'
require_relative './lib/parser'

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
    @jets = jets.chars.cycle.lazy.map(&{"<" => -1, ">" => 1})
    @fallen_rocks = 0
    @max_height = 0
    @rows = []

    @rocks = ROCKS.cycle
    next_rock
  end

  def next_rock
    @current_rock = @rocks.next
    @current_rock_pos = [@max_height+3, 2]
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
    try_move(0, @jets.next)
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

  def render
    @rows.reverse.each do |row|
      puts row.map(&{true => '#', false => '.'}).join
    end
  end
end

chamber = Chamber.new(AOC.get_input(17))
chamber.step while chamber.fallen_rocks < 2022
puts chamber.max_height