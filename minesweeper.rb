require_relative 'board'
require_relative 'player'

class MineSweeper

  def initialize(player)
    @player = player
    @board = Board.new

    run
  end

  def run
    system('clear')
    puts "Welcome to MineSweeper game!"
    until @board.won?|| @board.over?
      system('clear')
      @board.render
      play_turn
    end
    @board.render
  end

  def play_turn
    input_coord_move = @player.get_input
    curr_coord = input_coord_move.first
    curr_move = input_coord_move.last

    row_i, col_i = curr_coord
    if curr_move == "r"
      @board[curr_coord].reveal
      fringe_coords = @board.generate_adj_fringes_coords(curr_coord)
      # p fringe_coords
    else
      @board[curr_coord].flagged
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  print "Please enter your name: "
  input_name = gets.chomp
  m = MineSweeper.new(Player.new(input_name))
end
