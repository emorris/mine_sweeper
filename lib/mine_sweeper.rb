require_relative "board"

class MineSweeper

  def initialize

  end

  def move(y, x)
    @board.player_move(y, x)
  end

  def test 
    @board = Board.new(10,10,0)
    move(5, 5)
    running(true)
    end_state
  end

  def test2
    @board = Board.new(10,10,10*10)
    move(5, 5)
    running(true)
    end_state
  end

  def test3
    @board = Board.new(10,10,5)
    move(5, 5)
    running(true)
    end_state
  end

  def start()
    puts "Mine Sweeper. Will need to input.\nWidth?"
    width = gets.to_i
    puts "Height?"
    height = gets.to_i
    puts "Mine Count?"
    mine_count = gets.to_i
    @board = Board.new(width,height,mine_count)
    running
    end_state
  end


  protected

  def running(cheat = false)
    while @board.going
      puts "------ \n#{@board.peek}\n------ \n \n" if cheat
      puts "#{@board} \nPlease give us another move. \nX position?"  
      x = gets.to_i
      puts "Y position?"
      y = gets.to_i
      move(y, x)
    end
  end

  def end_state
    puts @board
    puts @board.winning_state ? "YOU WON! \n" : "YOU GOT MURDERED! \n"
  end

end
