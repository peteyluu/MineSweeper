require 'colorize'

class Tile
  attr_accessor :adj_bombs

  def initialize(coord, bomb)
    @coord, @bomb = coord, bomb
    @flagged = false
    @revealed = false
    @adj_bombs = 0
  end

  def bomb?
    @bomb
  end

  def fringe?
    return true if @adj_bombs > 0
  end

  def revealed?
    @revealed
  end

  def reveal
    @revealed = true if @flagged == false && @revealed == false
  end

  def to_s
    img = "$".colorize(:green) if @bomb == true && @revealed == true
    img = "F".colorize(:red) if @flagged == true
    img = "*" if @revealed == false && @flagged == false

    if @revealed == true && @adj_bombs > 0 && @bomb == false
      img = @adj_bombs.to_s.colorize(:blue)
    elsif @revealed == true && @adj_bombs == 0 && @bomb == false
      img = "_"
    end

    "#{img}"
  end

  def flagged
    if @revealed == false
      if @flagged == false
        @flagged = true
      else
        @flagged = false
      end
    end
  end
end
