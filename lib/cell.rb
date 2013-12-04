class Cell

  SIZE = 2

  attr_reader :x, :y, :color, :state
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
    @color = Gosu::Color::BLACK
  end

  def live
    @next_state = :alive
    @reincarnations +=1
    @color = Gosu::Color.from_hsv((@reincarnations*5)%360, 1.0, 1.0)
  end

  def left; @x - SIZE/2;  end

  def right; @x + SIZE/2 - 1;  end

  def top; @y - SIZE/2;  end

  def bottom; @y + SIZE/2 - 1;  end

  def draw(window, x_factor, y_factor)

    #color = alive? ? Gosu::Color::YELLOW : Gosu::Color::GRAY
    window.draw_quad(
        left*x_factor, top*y_factor, color,
        right*x_factor, top*y_factor, color,
        right*x_factor, bottom*y_factor, color,
        left*x_factor, bottom*y_factor, color
    )
  end

end