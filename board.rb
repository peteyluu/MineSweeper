require_relative 'tile'

class Board
  DELTAS = [
    [-1, 0], [-1, -1], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]
  ]

  attr_reader :grid, :grid_length

  def self.init_board
    grid = Array.new(9) { Array.new(9) }
  end

  def initialize(grid = Board.init_board)
    @grid = grid
    @grid_length = grid.length
    populate
    find_fringe_coords
  end

  def over?
    if @grid.flatten.any? { |tile| tile.revealed? == true && tile.bomb? == true }
      puts "You lose!"
      return true
    end
  end

  def won?
    temp_grid = @grid.flatten.select { |tile| tile.revealed? == true }
    if temp_grid.length == (grid_length * grid_length) - @bomb_coords.length
      puts "You win!"
      return true
    end
  end

  def generate_adj_fringes_coords(coord)
    adj_coords = DELTAS.map do |dx, dy|
      [coord[0] + dx, coord[1] + dy]
    end

    adj_coords.select! { |coord| in_bounds?(coord) && !is_a_bomb?(coord) && !is_a_fringe?(coord) }

    seen = deep_dup(adj_coords)

    until adj_coords.empty?
      curr_coord = adj_coords.shift
      new_coords = DELTAS.map do |dx, dy|
        [curr_coord[0] + dx, curr_coord[1] + dy]
      end

      new_coords.select! { |coord| in_bounds?(coord) && !is_a_bomb?(coord) && !is_a_fringe?(coord) && !seen.include?(coord) }

      seen += new_coords
      adj_coords += new_coords
    end

    update_tiles(seen.sort)
  end

  def update_tiles(coords)
    coords.each do |coord|
      row_i, col_i = coord
      @grid[row_i][col_i].reveal
    end
  end

  def find_fringe_coords
    fringe_coords = []
    @bomb_coords.each do |bomb_coord|
      row_i, col_i = bomb_coord
      DELTAS.each do |d_coord|
        row_j, col_j = d_coord
        new_coord = [row_i + row_j, col_i + col_j]
        if in_bounds?(new_coord) && !is_a_bomb?(new_coord)
          fringe_coords << new_coord
        end
      end
    end
    fringe_insert(fringe_coords)
  end

  def fringe_insert(coords)
    coords.each do |coord|
      row_i, col_i = coord
      @grid[row_i][col_i].adj_bombs += 1
    end
  end

  def is_a_fringe?(coord)
    row_i, col_i = coord
    @grid[row_i][col_i].fringe?
  end

  def is_a_bomb?(coord)
    row_i, col_i = coord
    @grid[row_i][col_i].bomb?
  end

  def in_bounds?(coord)
    row_i, col_i = coord
    row_i.between?(0, 8) && col_i.between?(0, 8)
  end

  def populate
    @bomb_coords = generate_coords_for_bomb
    @grid.each_with_index do |row, row_i|
      row.each_with_index do |col, col_i|
        curr_coord = [row_i, col_i]
        if @bomb_coords.include?(curr_coord)
          @grid[row_i][col_i] = Tile.new(curr_coord, true)
        else
          @grid[row_i][col_i] = Tile.new(curr_coord, false)
        end
      end
    end
  end

  def generate_coords_for_bomb
    num_of_bombs = (@grid.length * @grid.length) / 10
    bomb_coords = []
    until bomb_coords.length == num_of_bombs
      row_i = rand(9)
      col_i = rand(9)
      curr_coord = [row_i, col_i]
      bomb_coords << curr_coord unless bomb_coords.include?(curr_coord)
    end
    bomb_coords
  end

  def render
    header
    @grid.each_with_index do |row, row_i|
      row.each_with_index do |col, col_i|
        @grid[row_i][col_i].to_s
      end
      puts "#{row_i} #{row.join(' ')}"
    end
  end

  def header
    puts "  #{(0..8).to_a.join(' ')}"
  end

  def [](pos)
    row_i, col_i = pos
    @grid[row_i][col_i]
  end

  private

  def deep_dup(arr)
    result = []
    arr.each do |el|
      if el.is_a?(Array)
        result << deep_dup(el)
      else
        result << el
      end
    end
    result
  end
end

b = Board.new
