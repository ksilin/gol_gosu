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
    @generation = 0
    @elapsed_time = 0
    @font = Gosu::Font.new(self, 'Arial', 48)
  end

  def update

    @elapsed_time = Gosu::milliseconds()

    if (@generation % 6 == 0)
      @world.update
      p "updating"
    end
    @generation +=1
  end

  def draw
    @world.draw self
    @font.draw(@generation, 30, 30, 0)
    @font.draw(@world.alive_cells, WIDTH - 100, 30, 0)
    @font.draw(Gosu.fps, WIDTH/2, 30, 0)
    #@font.draw(@elapsed_time, WIDTH/2, 30, 0)
  end


  def button_down(id)
    case id
      when Gosu::KbEscape
        close
    end
  end

end

Golgosu.run
