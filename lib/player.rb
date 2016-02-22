require_relative "board"
class Player
  
  def initialize(number_of_games)
    @test = false
    @number_of_games = number_of_games
    @wins, @lost, @moves_made  = 0, 0, 0
    @best_score = -1000;
    @height, @width, @mine_number = 10, 10, 10
    @ranked_moves, @random_moves = [], []
    @random = Random.new
    @all_possible_moves = @height * @width - @mine_number 
  end

  def run_test
    i = 0
    while (@number_of_games > i)
      new_game
      i += 1
      end_game
    end
    results
  end



  protected

  def results
    puts "Wins: #{@wins} and Lost: #{@lost}"
    percentage = (@wins.to_f/@number_of_games.to_f * 100.0)
    puts "#{percentage}% of games won."
  end

  def new_game
    @board = Board.new()
    @moves_made = 1
    while @board.going
      rank_moves
      move(find_best_move)
      @moves_made += 1
    end
  end

  def debug
    puts "@moves_made #{@moves_made}"
    puts @board
    puts "--------------"
    puts "--------------"
    puts @board.peek
    puts "random_moves"
    p @random_moves
    puts "ranked_moves"
    p @ranked_moves
    puts "possible_moves #{@board.possible_moves}"
    p @board.possible_moves.length

  end

  def spaces_open
    @all_possible_moves - @board.possible_moves.length
  end

  def find_best_move
    if @point_to_use && @best_score > 0 && spaces_open > 5
      move = @point_to_use
    else
      if @random_moves.length > 0
        move = @random_moves[@random.rand(@random_moves.length)]
      else
        debug
        raise "Should always have a move"
      end
    end
    move
  end

  def rank_moves
    @random_moves = []
    @point_to_use = nil
    @best_score = -1000
    @board.possible_moves_and_neighbors_v2 do |position, neighbors|
      number_count, surrounding_points, not_visible = 0,0,0
      neighbors.each do |point|
        if point.visible
          surrounding_points += 1
          number_count += (point.state * point.state )
        else
          not_visible += 1
        end
      end
      score = score_the_point(position, number_count, not_visible, surrounding_points,neighbors.length)
      rank_score(score, position)
      @random_moves << position
    end

  end
  
  def rank_score(score, position)
    if @best_score < score 
      @best_score = score
      @point_to_use = position
    end
  end
  
  def score_the_point(position, number_count, not_visible, surrounding_points, sides)
    return -1  if surrounding_points == 0
    diff = sides - surrounding_points 
    return number_count if diff == 0
    score = (1000 - (number_count * sides/diff )) 
    return score
  end

  def end_game
    @board.winning_state ? @wins += 1 : @lost += 1
    if !@board.winning_state  && @test
      puts "best_score #{@best_score}"
      puts "-----------------------"
      puts @board 
    end
  end

  def move(point)
    @board.player_move(point[0], point[1])
  end
end

