class Cell

  attr_reader :x, :y, :state
  attr_reader :next_state

  def initialize(x, y, state = random_state)
    @x, @y = x, y
    @state, @next_state = state
    @reincarnations = 0
    alive? ? live : die
  end

  def switch_to_next_state
    @state = @next_state
  end

  def alive?
    :alive == state
  end

  def random_state
    rand > 0.5 ? :alive : :dead
  end

  def die
    @next_state = :dead

    # @color = Gosu::Color::BLACK
  end

  def live
    @next_state = :alive
    @reincarnations +=1
    # @color = Gosu::Color.from_hsv((@reincarnations*5)%360, 1.0, 1.0)
  end

  def left; @x; end
  def right; @x + 0.9; end
  def top; @y; end
  def bottom; @y + 0.9; end

end