module CellRenderer

  def self.draw(world, window)
    world.each { |cell| draw_cell(cell, window) }
  end


  def self.draw_cell(cell, window)
    color = cell.alive? ? Gosu::Color.from_hsv((cell.reincarnations*3)%360, 1.0, 1.0) : Gosu::Color::BLACK
    window.draw_quad(
        left(cell), top(cell), color,
        right(cell), top(cell), color,
        right(cell), bottom(cell), color,
        left(cell), bottom(cell), color)
  end

  def self.left(cell)
    cell.x
  end

  def self.right(cell)
    cell.x + 0.9
  end

  def self.top(cell)
    cell.y
  end

  def self.bottom(cell)
    cell.y + 0.9
  end

end