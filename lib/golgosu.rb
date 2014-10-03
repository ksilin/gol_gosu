require 'hasu'

#Hasu.load 'world.rb'
require_relative 'world'

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

    if (@frames % 1 == 0)
      @world.update
    end

    if button_down? Gosu::MsLeft
      puts "drawing glider at #{mouse_x/@x_factor}, #{mouse_y/@y_factor}"
      @world.draw_glider(mouse_x/@x_factor, mouse_y/@y_factor)
      #@world.revive_around(mouse_x, mouse_y)
    end
  end

  def draw

    scale(@x_factor, @y_factor, 0, 0) {
      @world.each { |cell| draw_cell(cell)}
    }
    #@font.draw(@frames, 30, 20, 0)
    @font.draw("gen #{@world.generations}", 30, 20, 0)
    @font.draw("alive: #{@world.alive_cells}", WIDTH - 100, 20, 0)
    @font.draw("fps: #{Gosu.fps}", 30, 50, 0)
  end


  def draw_cell(cell)
    color = cell.alive? ? Gosu::Color::GREEN : Gosu::Color::BLACK
    draw_quad(
        cell.left, cell.top, color,
        cell.right, cell.top, color,
        cell.right, cell.bottom, color,
        cell.left, cell.bottom, color)
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
