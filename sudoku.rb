require 'colorize'

class Tile
  attr_reader :given
  attr_accessor :value

  def initialize(value = 0)
    @value = value
    if @value == "0"
      @given = :empty
    else
      @given = :given
    end
  end

  def to_s
    if @given == :given
       @value.colorize(:blue)
    else
      @value
    end
  end
end

class Board

  def self.from_file(file_name)
    grid = []
    file_arr = File.readlines(file_name).map(&:chomp)
    file_arr.each do |line|
      subgrid = []
      line.each_char do |char|
          subgrid << Tile.new(char)
      end
      grid << subgrid
    end
    Board.new(grid)
  end

  def initialize(grid)
    @grid = grid
  end

  def render
    @grid.each do |line|
      line.each do |tile|
        print tile.to_s
      end
      puts
    end
    nil
  end

  def position(pos, value)
    if @grid[pos[0]][pos[1]].given == :given
      puts "Can't change this"
      puts
      return
    end
    @grid[pos[0]][pos[1]].value = value
  end

  def solved?
    line_arr = []
    @grid.each do |line|
      sub_line_arr = []
      line.each do |tile|
        sub_line_arr << tile.value
      end
      line_arr << sub_line_arr
    end
    solved = ("1".."9").to_a
    line_arr.each do |line|
      if solved == line.sort
      else
        return false
      end
    end
    col_grid = line_arr.transpose
    col_grid.each do |line|
      if solved == line.sort
      else
        return false
      end
    end

    count_row = 3
    count_col = 3
    until count_row > 9
      box = []
      until count_col > 9
      (count_row-3...count_row).each do |row|
          (count_col-3...count_col).each do |col|
            box << line_arr[row][col]
          end
        end
        count_col += 3
        if solved == box.sort
        else
          return false
        end
        box = []
      end
      count_row += 3
      count_col = 0
    end
    true
  end
end

class Game

  NUMBERS = ("1".."9")

  def initialize(board)
    @board = board
  end

  def play
    until @board.solved?
      @board.render
        input = prompt
        @board.position(*input)
      end
      puts
      puts "You solved the puzzle!"
    end

    def prompt
      row = nil
      col = nil
      entry = nil
      until valid?(row)
        puts "Enter row (1-9):"
        row = gets.chomp
      end
      until valid?(col)
        puts "Enter column(1-9):"
        col = gets.chomp
      end
      until valid?(entry)
        puts "Enter value you would like(1-9)"
        entry = gets.chomp
      end
      [[row.to_i - 1 , col.to_i - 1], entry]
    end

    def valid?(item)
      NUMBERS.include?(item)
    end



end
