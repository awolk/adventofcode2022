# Helper methods for Advent of Code solutions
module AOC
  def self.get_input(day)
    File.read(File.expand_path("../input/day#{day}.txt", __dir__))
  end
end
