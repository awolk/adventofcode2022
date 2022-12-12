require 'matrix'
# Helper methods for Advent of Code solutions
module AOC
  def self.get_input(day)
    File.read(File.expand_path("../../input/day#{day}.txt", __dir__))
  end

  def self.digit_matrix(input)
    Matrix.rows(input.split("\n").map { _1.chars.map(&:to_i) })
  end

  def self.char_matrix(input)
    Matrix.rows(input.split("\n").map(&:chars))
  end
end
