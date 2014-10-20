require 'hasu'

require_relative 'world'
require_relative 'cell_renderer'

class Golgosu < Hasu::Window

  WIDTH = 640
  HEIGHT = 480

  def initialize
    super(WIDTH, HEIGHT, false)
  end

  def reset
    @world = World.new(128, 96)
    @x_factor = width/@world.width
    @y_factor = height/@world.height
    @frames = 0
    @elapsed_time = 0
    @font = Gosu::Font.new(self, 'Arial', 24)
  end

  def update
    @frames +=1

    if (@frames % 3 == 0)
      @world.update
    end

    if button_down? Gosu::MsLeft
      @world.draw_glider(mouse_x/@x_factor, mouse_y/@y_factor)
    end
  end

  def draw

    scale(@x_factor, @y_factor, 0, 0) {
      @world.each { |cell| CellRenderer.draw(cell, self) }
    }
    @font.draw("gen #{@world.generations}", 30, 20, 0)
    @font.draw("alive: #{@world.alive_cells}", WIDTH - 100, 20, 0)
    @font.draw("fps: #{Gosu.fps}", 30, 50, 0)
  end


  def button_down(id)
    case id
      when Gosu::KbEscape
        close
      when Gosu::KbD
        @world.kill_all
      when Gosu::KbF
        @world.revive_all
      when Gosu::KbSpace
        @world.next_rule
      when Gosu::KbP
        @world.toggle_pause
      when Gosu::KbB
        @world.switch_brush
    end
  end

  def needs_cursor?
    true
  end
end

Golgosu.run
