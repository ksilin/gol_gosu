class Cell

  SIZE = 4

  attr_reader :x, :y, :color, :state

  def initialize(x, y, state = random_state, color = Gosu::Color::WHITE)
    @x = x
    @y = y
    @state = state
    @color = color
  end

  def update
    case @state
    when :alive
      brighter
    when :dead
      dimmer
    end
  end

  def alive?
    :alive == state
  end

  def random_state
    rand > 0.5 ? :alive : :dead

  end

  def dimmer(factor = 0.99)
    @color.value *= factor unless @color.value <= 0
  end

  def brighter(factor = 1.05)
    @color.value *= factor unless @color.value >= 1
  end

  def die; @state = :dead; end
  def live; @state = :alive; end

  def x1; @x - SIZE/2;  end

  def x2; @x + SIZE/2;  end

  def y1; @y - SIZE/2;  end

  def y2; @y + SIZE/2;  end

  def draw(window)

    color = alive? ? Gosu::Color::YELLOW : Gosu::Color::GRAY

    window.draw_quad(
        x1, y1, color,
        x2, y1, color,
        x2, y2, color,
        x1, y2, color
    )
  end

end