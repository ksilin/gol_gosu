class Cell

  SIZE = 4

  attr_reader :x, :y, :color, :state
  attr_reader :next_state

  def initialize(x, y, state = random_state)
    @x, @y = x, y
    @state, @next_state = state
    @reincarnations = 0
    alive? ? live : die
  end

  def update
    alive? ? brighter : dimmer
  end

  def switch_to_next_state
    @state = @next_state
  end

  def alive?
    :alive == state
  end

  def random_state
    state = rand > 0.5 ? :alive : :dead
    state
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

  def x1; @x - SIZE/2;  end

  def x2; @x + SIZE/2;  end

  def y1; @y - SIZE/2;  end

  def y2; @y + SIZE/2;  end

  def draw(window)

    #color = alive? ? Gosu::Color::YELLOW : Gosu::Color::GRAY
    window.draw_quad(
        x1, y1, color,
        x2, y1, color,
        x2, y2, color,
        x1, y2, color
    )
  end

end