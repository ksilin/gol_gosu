class OsdRenderer

  def initialize(window)
    @font = Gosu::Font.new(window, 'Arial', 24)
  end

  def draw(world)
    @font.draw("gen #{world.generations}", 30, 20, 0)
    @font.draw("alive: #{world.alive_cells}", 540, 20, 0)
    @font.draw("fps: #{Gosu.fps}", 30, 50, 0)
  end
end