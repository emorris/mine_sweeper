require_relative "point"

class Board
  attr_reader :going, :winning_state, :open_points, :possible_moves

  def initialize(height = 10, width = 10 , number_of_mines =10)
    @height = height
    @width = width
    @number_of_mines = number_of_mines
    @board_data = []
    @possible_moves = {}
    @going = true
    @winning_state = false

    initial_board()
  end

  def player_move(y, x)
    point =  @board_data[y][x]
    return if point.visible

    point_visible!(point, y, x)
    if point.mine?
      @going, @winning_state = false
    else
      expain_hit(y,x) unless point.number?
      check_if_winning
    end
  end

  def to_s
    print
  end

  def peek
    print(true)
  end

  def possible_moves_and_neighbors
    @board_data.each_with_index do |arr, y|
      arr.each_with_index do |point, x|
        unless point.visible
          neighbors = get_neighbors(y, x, true)
          yield [y,x], neighbors
        end
      end
    end
  end

  def possible_moves_and_neighbors_v2
    @possible_moves.each do |key, val|
      point = @board_data[val[0]][val[1]]
      unless point.visible
        neighbors = get_neighbors(val[0], val[1], true)
        yield [val[0], val[1]], neighbors
      end
    end
  end

  def get_valid_neighbors(y,x)
    get_neighbors(y, x).each do |set|
      yield set[0], set[1] if block_given?
    end
  end

  protected

  def initial_board
    @board_data = Array.new(@height) { Array.new(@width){ Point.new() }}
    add_bombs
    create_possible_moves
  end

  def create_possible_moves
    @board_data.each_with_index do |arr, y|
      arr.each_with_index do |point, x|
        @possible_moves["#{y}_#{x}"] = [y,x]
      end
    end
  end
  
  def point_visible!(point, y, x)
    point.visible!
    @possible_moves.delete("#{y}_#{x}")
  end

  def print(peek = false)
    output = ""
    y = 0
    padding ="  "
    @width.times {|i| output += "#{i}#{padding}" }
    @board_data.each do |arr|
      output += "\n"
      arr.each do |point|
        peek ? output += "#{point.peek}#{padding}" : output += "#{point}#{padding}" 
      end
      output += "#{y}#{padding}" if (y) < @height
      y+=1
    end
    output
  end

  def expain_hit(y,x)
    get_valid_neighbors(y,x) do |y1,x1|
      point = @board_data[y1][x1]
      unless point.visible
        point_visible!(point,y1, x1)
        expain_hit(y1,x1) if point.empty? 
      end
    end
  end

  def add_bombs
    mines = {}
    bomb_count = 0
    r = Random.new()
    while mines.length != @number_of_mines
      x = r.rand(@width)
      y = r.rand(@height)
      hash_key = "#{y}_#{x}"
      unless mines.key?(hash_key)
        mines[hash_key] = [y,x]
        @board_data[y][x].mine!
        increment_counts(y,x)
      end
    end
    if mines.length > @number_of_mines
      raise "How can mines be greater"
    end
  end

  def increment_counts(y,x)
    get_valid_neighbors(y,x) do |x,y|
      @board_data[x][y].increment_count!
    end
  end

  def valid_position(y, x, arr, add_object = false)
   if x >= 0 && y >= 0 && x < @width && y < @height 
    add_object ? arr << @board_data[y][x] : arr << [y, x]
   end 
   arr
  end

  def get_neighbors(y,x, add_object =false)
    positions = []
    valid_position(y, x-1, positions, add_object)
    valid_position(y+1,x-1, positions, add_object) 
    valid_position(y+1, x, positions, add_object) 
    valid_position(y+1,x+1, positions, add_object) 
    valid_position(y,x+1, positions, add_object) 
    valid_position(y-1,x+1, positions, add_object) 
    valid_position(y-1,x, positions, add_object) 
    valid_position(y-1,x-1, positions, add_object) 
  end

  def check_if_winning
    if @possible_moves.length == @number_of_mines
      @going = false
      @winning_state = true
    end
  end

end