require 'hasu'

require_relative 'world'
require_relative 'ui/cell_renderer'
require_relative 'ui/osd_renderer'

class Golgosu < Hasu::Window

  WIDTH = 640
  HEIGHT = 480

  def initialize
    super(WIDTH, HEIGHT, false)
    @osd = OsdRenderer.new(self)
  end

  def reset
    @world = World.new(128, 96)
    @x_factor = width/@world.width
    @y_factor = height/@world.height
    @frames = 0
    @elapsed_time = 0
  end

  def update
    @frames +=1

    if (@frames % 3 == 0)
      @world.update
    end

    if button_down? Gosu::MsLeft
      @world.add_glider((mouse_x/@x_factor).round, (mouse_y/@y_factor).round)
    end
  end

  def draw
    scale(@x_factor, @y_factor, 0, 0) {
      @world.each { |cell| CellRenderer.draw(cell, self) }
    }
    @osd.draw(@world)
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
