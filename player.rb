class Player
  
  def initialize(name)
    @name = name
  end

  def get_input
    print "Enter a position (i.e. 0,0): "
    input_coord = gets.chomp.split(',').map { |char| char.to_i }
    until valid_input_coord?(input_coord)
      input_coord = gets.chomp.split(',').map { |char| char.to_i }
    end

    print "Enter \"r\" to reveal or enter \"f\" to flag: "
    input_move = gets.chomp
    until valid_input_move?(input_move)
      input_move = gets.chomp
    end

    [input_coord, input_move]
  end

  def valid_input_move?(move)
    move == 'r' || move == 'f'
  end

  def valid_input_coord?(coord)
    row_i, col_i = coord
    row_i.between?(0, 8) && col_i.between?(0, 8)
  end
end
