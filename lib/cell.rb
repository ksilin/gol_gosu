class Cell

  attr_reader :x, :y, :state, :reincarnations
  attr_accessor :next_state

  def initialize(x, y, state)
    @x, @y = x, y
    @state, @next_state = state
    @reincarnations = 0
  end

  def switch_to_next_state
    @state = @next_state
    @reincarnations +=1 if :alive == state
  end

  def alive?
    :alive == state
  end

end