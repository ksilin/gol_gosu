require 'hasu'

Hasu.load 'world.rb'

class Golgosu < Hasu::Window

  WIDTH = 640
  HEIGHT = 480

  def initialize
    super(WIDTH, HEIGHT, false)
  end

  def reset
    @world = World.new(self,128, 96)
    @frames = 0
    @elapsed_time = 0
    @font = Gosu::Font.new(self, 'Arial', 24)
  end

  def update
    if (@frames % 1 == 0)
      @world.update
    end
    @frames +=1
  end

  def draw
    @world.draw self
    @font.draw(@frames, 30, 20, 0)
    @font.draw("gen #{@world.generations}", 30, 50, 0)
    @font.draw("alive: #{@world.alive_cells}", WIDTH - 100, 30, 0)
    @font.draw("fps: #{Gosu.fps}", 30, 80, 0)
  end

  def button_down(id)
    case id
      when Gosu::KbEscape
        close
    end
  end
end

Golgosu.run
