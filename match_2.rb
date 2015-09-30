#!/usr/bin/env ruby

class Card

attr_reader :value, :state

  def initialize(value)
    @value = value
    @state = :hidden
  end

  def display
    print "x" if @state == :hidden
    print value if @state == :show
  end

  def hide
      @state = :hidden
  end

  def reveal
    @state = :show
  end

  def ==(other_card)
    self.value == other_card.value
  end

end

class Board
  attr_reader :grid, :guesses, :board_size

  def initialize(size)
    @grid = Array.new(size) {Array.new}
    @guesses = {}
    @board_size = size
  end

  def populate
    card_array = []
    card_index = 0
    (0..((@board_size ** 2)/2)).each do |number|
      2.times { card_array << Card.new(number) }
    end
    card_array.shuffle!
    @grid.each do |array|
      @board_size.times do
        array << card_array[card_index]
        card_index += 1
      end
    end
  end

  def display
    @grid.each do  |arr|
      puts
      arr.each do |card|
        card.display
      end
    end
    puts
    puts
  end

  def won?
    @grid.each do |array|
      return false unless array.all? { |card| card.state == :show }
    end
  end

  def reveal(guess)
    chosen_card = @grid[guess[0]][guess[1]]
    return nil if chosen_card.state == :show
    chosen_card.reveal
    @guesses[guess] = chosen_card.value
    chosen_card
  end

  def clear_cards(card)
    @guesses.delete_if{ |_,v| v == card.value }
  end
end

class Game

  def initialize(player1, player2, board_size)
    @board = Board.new(board_size)
    @guessed = []
    @player1 = player1
    @player2 = player2
    @current_player = player1
  end

  def play
    @board.populate
    @board.display
    until @board.won?
      print @current_player.name + " "
      card_1 = @current_player.prompt(@board)
      @board.display unless @current_player.is_a?(ComputerPlayer)
      card_2 = @current_player.prompt(@board)
      if card_1 == card_2
        @board.display
        @board.clear_cards(card_1)
        puts "The cards match."
      else
        @board.display
        puts "The cards do not match."
        sleep 2
        system("clear")
        card_1.hide
        card_2.hide
        @board.display
      end
      @current_player.clear_next if @current_player.is_a?(ComputerPlayer)
      switch_player
    end
    puts "You won the game!"
  end

  def switch_player
    @current_player = (@current_player == @player1 ? @player2 : @player1)
  end

end

class Player

attr_reader :name

  def initialize(name)
    @name = name
  end

  def prompt(board)
    row = nil
    col = nil
    until valid_guess?(row, board)
      puts "please enter row (0-#{board.board_size - 1})"
      row = gets.chomp
    end
    until valid_guess?(col, board)
      puts "please enter col (0-#{board.board_size - 1})"
      col = gets.chomp
    end
    guess = [row.to_i, col.to_i]
    board.reveal(guess) || prompt(board)
  end

  def valid_guess?(guess, board)
    ("0"..(board.board_size - 1).to_s).include?(guess)
  end

end

class ComputerPlayer < Player

attr_reader :name

  def initialize
    @next_guess = []
    @name = "Computer"
  end

  def prompt(board)
    if @next_guess == []
      return board.reveal(matching_move(board)) unless matching_move(board).nil?
      board.reveal([rand(board.board_size - 1), rand(board.board_size - 1)]) || prompt(board)
    else
      board.reveal(@next_guess)
    end
  end

  def matching_move(board)
    board.guesses.each_pair do |key1, value1|
      board.guesses.each_pair do |key2, value2|
        if value1 == value2 && key1 != key2
          @next_guess = key2
          return key1
        end
      end
    end
    nil
  end

  def clear_next
    @next_guess = []
  end

end

if __FILE__ == $PROGRAM_NAME
  puts "Who is the first player?"
  player1 = gets.chomp
  player1 = Player.new(player1)
  puts "Who is the second player? (Enter COMP for computer)"
  player2 = gets.chomp
  if player2 == "COMP"
    player2 = ComputerPlayer.new
  else
    player2 = Player.new(player2)
  end
  puts "What difficulty would you like"
  puts "Easy 3x3"
  puts "Medium 4x4"
  puts "Hard 5x5"
  board_diff = gets.chomp
  case board_diff.downcase
  when "easy"
    board_size = 3
  when "medium"
    board_size = 4
  when "hard"
    board_size = 5
  else
    puts "Wrong size name, playing medium"
    board_size = 8
  end
  g = Game.new(player1, player2, board_size)
  g.play
end
