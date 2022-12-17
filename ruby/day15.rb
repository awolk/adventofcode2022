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
    return [] if width <= 0
    (x-width..x+width)
  end
end

parser = P.seq(
  "Sensor at x=", P.int, ", y=", P.int, ": closest beacon is at x=", P.int, ", y=", P.int
).map {|x1, y1, x2, y2| Sensor.new([x1, y1], [x2, y2])}.each_line
input = parser.parse_all(AOC.get_input(15))

def not_beacons_in_row(sensors, row)
  beacons = sensors.map(&:beacon).filter_map {|x, y| x if y == row}.to_set
  pts = sensors.flat_map do |sensor|
    sensor.pts_in_row(row).to_a
  end.to_set
  pts - beacons
end

puts not_beacons_in_row(input, 2000000).size