require 'set'
require_relative './lib/aoc'
require_relative './lib/parser'

Sensor = Struct.new(:position, :beacon) do
  def x = position[0]
  def y = position[1]
  def bx = beacon[0]
  def by = beacon[1]

  def dist
    (x - bx).abs + (y - by).abs
  end

  def pts_in_row(row)
    width = dist - (row - y).abs
    return nil if width <= 0
    (x-width..x+width)
  end
end

def overlap?(r1, r2)
  r1.cover?(r2.first) || r2.cover?(r1.first)
end

def combine(r1, r2)
  [r1.first, r2.first].min .. [r1.last, r2.last].max
end

def intersect(r1, r2)
  return nil if !overlap?(r1, r2)
  [r1.first, r2.first].max .. [r1.last, r2.last].min
end

def visible_ranges(sensors, row)
  ranges = sensors.filter_map do |sensor|
    sensor.pts_in_row(row)
  end.to_set

  loop do
    overlap = ranges.to_a.combination(2).find do |r1, r2|
      overlap?(r1, r2)
    end
    break if overlap.nil?

    ranges.subtract(overlap)
    ranges.add(combine(*overlap))
  end
  
  ranges
end

def beacons(sensors, row)
  sensors.map(&:beacon).filter_map {|x, y| x if y == row}.uniq
end

def not_beacons_in_row(sensors, row)
  beacon_count = beacons(sensors, row).size
  visible_count = visible_ranges(sensors, row).sum(&:size)
  visible_count - beacon_count
end

parser = P.seq(
  "Sensor at x=", P.int, ", y=", P.int, ": closest beacon is at x=", P.int, ", y=", P.int
).map {|x1, y1, x2, y2| Sensor.new([x1, y1], [x2, y2])}.each_line
sensors = parser.parse_all(AOC.get_input(15))

pt1 = not_beacons_in_row(sensors, 2000000)
puts "Part 1: #{pt1}"

SIZE = 4000000
(0..SIZE).each do |y|
  # print progress every 2%
  if y % 80000 == 0
    puts "#{(y.to_f / SIZE * 100).round}%"
  end

  visible = visible_ranges(sensors, y).filter_map do |range|
    intersect(range, 0..SIZE)
  end

  visible_count = visible.sum(&:size)
  if visible_count == SIZE
    x = visible.sort_by(&:first).first.last + 1
    pt2 = y + x * 4000000
    puts "Part 2: #{pt2}"
    break
  end
end