class Point
  NOT_VISIBLE = "◼"
  EMPTY_SPACE = "."
  MINE = "M"
  attr_reader :visible

  def initialize
    @state = EMPTY_SPACE
    @visible = false
    @is_number = false
  end

  def visible!
    @visible = true
  end

  def mine!
    @state = MINE
  end

  def mine?
    MINE == @state
  end

  def number?
    @is_number
  end

  def state
    raise "Can't check state on nonvisible point" unless @visible
    @state
  end

  def empty?
    EMPTY_SPACE == @state
  end

  def increment_count!
    return if mine? 
    number? ? @state += 1 : @state = 1
    @is_number = true
  end
  
  def peek
    @is_number ? @state.to_s : @state
  end
  
  def to_s
    return NOT_VISIBLE unless @visible
    @is_number ? @state.to_s : @state
  end

end