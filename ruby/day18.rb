require 'set'
require_relative './lib/aoc'
require_relative './lib/parser'

def adjacent(pt)
  x, y, z = pt
  [
    [x+1, y, z], [x-1, y, z],
    [x, y+1, z], [x, y-1, z],
    [x, y, z+1], [x, y, z-1],
  ]
end

class Graph
  def initialize(pts)
    @pts = pts
    minx, maxx = pts.map {_1[0]}.minmax
    miny, maxy = pts.map {_1[1]}.minmax
    minz, maxz = pts.map {_1[2]}.minmax
    @xrange = minx..maxx
    @yrange = miny..maxy
    @zrange = minz..maxz

    @known_exposed = Set[]
    @known_contained = Set[]
  end

  def adjacent_spaces(pt)
    adjacent(pt).reject {|pt| @pts.include?(pt)}
  end

  def contained_space?(pt) = @known_contained.include?(pt)

  def dfs(start_pt)
    # if we already have the classification then we're good!
    return if @known_contained.include?(start_pt) || @known_exposed.include?(start_pt)

    visited = Set[]
    stack = [start_pt]
    loop do
      if stack.empty?
        # we visited everything, so must be fully contained
        @known_contained.merge(visited)
        return
      end

      pt = stack.pop
      next if visited.include?(pt)
      visited.add(pt)

      if @known_exposed.include?(pt)
        # we've reached the outside, so this is exposed
        @known_exposed.merge(visited)
        return
      end

      if @known_contained.include?(pt)
        # we've reached a known contained space, so this is contained
        @known_contained.merge(visited)
        return
      end

      x, y, z = pt
      if !@xrange.cover?(x) || !@yrange.cover?(y) || !@zrange.cover?(z)
        # we made it outside the bounds, so this is not contained
        @known_exposed.merge(visited)
        return
      end

      stack.concat(adjacent_spaces(pt).reject {visited.include?(_1)})
    end
  end
end

parser = P.int.delimited(',').each_line
pts = parser.parse_all(AOC.get_input(18)).to_set
graph = Graph.new(pts)

# Part 1
pt1 = pts.sum do |pt|
  graph.adjacent_spaces(pt).size
end
puts "Part 1: #{pt1}"

# Part 2
pt2 = pts.sum do |pt|
  graph.adjacent_spaces(pt).count do |adj|
    graph.dfs(adj)
    !graph.contained_space?(adj)
  end
end
puts "Part 2: #{pt2}"