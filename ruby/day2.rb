require_relative './aoc'

MOVES = {
  "R" => {
    score: 1,
    beats: "S",
    loses: "P"
  },
  "P" => {
    score: 2,
    beats: "R",
    loses: "S"
  },
  "S" => {
    score: 3,
    beats: "P",
    loses: "R"
  }
}

LOSE = 0
DRAW = 3
WIN = 6

def score(games)
  games.sum do |(opp, you)|
    result =
      if opp == you
        DRAW
      elsif MOVES.dig(opp, :beats) == you
        LOSE
      else
        WIN
      end
    MOVES.dig(you, :score) + result
  end
end

lines = AOC.get_input(2).split("\n")

pt1_games = lines.map do |line|
  line.split.map do |move|
    move.tr('ABCXYZ', 'RPSRPS')
  end
end
puts "Part 1: #{score(pt1_games)}"

pts2_games = lines.map do |line|
  opp, you = line.split
  opp.tr!('ABC', 'RPS')
  you =
    if you == 'X'
      MOVES.dig(opp, :beats)
    elsif you == 'Y'
      opp
    else
      MOVES.dig(opp, :loses)
    end
  [opp, you]
end
puts "Part 2: #{score(pts2_games)}"