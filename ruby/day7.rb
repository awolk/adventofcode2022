require_relative './lib/aoc'

PFile = Struct.new(:name, :size)

class PDirectory
  attr_reader :name, :parent

  def initialize(name, parent)
    @name = name
    @parent = parent
    @contains = {}
  end

  def get(name)
    @contains[name]
  end

  def add(file_or_dir)
    @contains[file_or_dir.name] = file_or_dir
  end

  def size
    @contains.values.sum(&:size)
  end

  def all_reachable_directories
    [self] + child_directories.flat_map(&:all_reachable_directories)
  end

  def child_directories
    @contains.values.filter {|c| c.is_a?(PDirectory)}
  end
end

input = AOC.get_input(7)

outmost = PDirectory.new('/', nil)
cwd = outmost

sections = input.split("$").map(&:strip)[1..]
sections.each do |section|
  lines = section.split("\n")
  cmd = lines[0]
  output = lines[1..]

  if cmd.start_with?('cd ')
    path = cmd.split(' ')[1]
    if path == '/'
      cwd = outmost
    elsif path == '..'
      cwd = cwd.parent
    else
      cwd = cwd.get(path)
    end
    raise "unkown directory #{path}" if cwd.nil?
  elsif cmd == 'ls'
    output.each do |line|
      detail, name = line.split
      if detail == 'dir'
        cwd.add(PDirectory.new(name, cwd))
      else
        cwd.add(PFile.new(name, detail.to_i))
      end
    end
  else
    raise "unknown command #{cmd}"
  end
end

all_directory_sizes = outmost.all_reachable_directories.map(&:size)
pt1 = all_directory_sizes.select{ _1 <= 100000}.sum
puts "Part 1: #{pt1}"

total = 70000000
need_unused = 30000000
used = outmost.size
unused = total - used
must_delete = need_unused - unused
pt2 = all_directory_sizes.sort.find {_1 >= must_delete}
puts "Part 2: #{pt2}"