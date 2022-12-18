require 'set'
require_relative './lib/aoc'
require_relative './lib/parser'

Sensor = Struct.new(:position, :beacon) do
  def x = position[0]
  def y = position[1]
  def bx = beacon[0]
  def by = beacon[1]

  def dist
    @dist ||= (x - bx).abs + (y - by).abs
  end

  def pts_in_row(row)
    width = dist - (row - y).abs
    return nil if width <= 0
    x-width .. x+width
  end
end

def overlap?(r1, r2)
  r1.cover?(r2.first) || r2.cover?(r1.first)
end

def restrict_ranges(ranges, bound)
  ranges.filter_map do |range|
    if overlap?(range, bound)
      [range.first, bound.first].max .. [range.last, bound.last].min
    end
  end
end

def consolidate_ranges(ranges)
  ranges = ranges.sort_by(&:first)

  res = [ranges.shift]
  ranges.each do |range|
    if res.last.cover?(range.first)
      old_range = res.pop
      res.push(old_range.first .. [old_range.last, range.last].max)
    else
      res.push(range)
    end
  end
  res
end

def visible_ranges(sensors, row)
  ranges = sensors.filter_map do |sensor|
    sensor.pts_in_row(row)
  end
  consolidate_ranges(ranges)
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

bound = 0..4000000
bound.each do |y|
  AOC.report_progress(y, 4000000, 5)
  visible = restrict_ranges(visible_ranges(sensors, y), bound)
  if visible.sum(&:size) == bound.size - 1
    x = visible.first.last + 1
    pt2 = y + x * 4000000
    puts "Part 2: #{pt2}"
    return
  end
end