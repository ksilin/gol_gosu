require 'hasu'
require 'golgosu'
Hasu.load 'cell.rb'

class World

  attr_reader :width, :height, :rules

  WIDTH = 100
  HEIGHT = 60

  def initialize(window, width = WIDTH, height = HEIGHT, rules = [[3],[2, 3]])
    @window = window
    @width = width
    @height = height
    @rules = rules

    @x_factor = @width/Golgosu::WIDTH
    @y_factor = @height/Golgosu::HEIGHT

    @world = Array.new(height) { |y| Array.new(width) { |x| Cell.new(x*5, y*5) } }
  end

  def revive(x, y)
    #@world[x][y].live if @world[x][y]
    [[-1, 0], [1, 0], [0, 0], # sides
     [-1, 1], [0, 1], [1, 1], # over
     [-1, -1], [0, -1], [1, -1] # under
    ].each do |pos|
       @world[(y + pos[0]) % @height][(x + pos[1]) % @width].live
    end
  end

  # Any live cell with fewer than two live neighbours dies, as if caused by under-population.
  # Any live cell with two or three live neighbours lives on to the next generation.
  # Any live cell with more than three live neighbours dies, as if by overcrowding.
  # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
  def update

    buffer = @world.dup

    buffer.each_with_index { |row, y|
      row.each_with_index { |cell, x|

        neighbors = alive_neighbours(x, y)
        case cell.state
          when :alive
            cell.die unless rules[1].include? neighbors
          when :dead
            cell.live if rules[0].include? neighbors
        end

        #cell.update
      }
    }
    @world = buffer

    if @window.button_down? Gosu::MsLeft
      revive((@window.mouse_x/5).tap { |x| p x }, (@window.mouse_y/5).tap { |y| p y })
    end

  end

  def alive_neighbours(y, x)
    [[-1, 0], [1, 0], # sides
     [-1, 1], [0, 1], [1, 1], # over
     [-1, -1], [0, -1], [1, -1] # under
    ].inject(0) do |sum, pos|
      sum +=1 if @world[(y + pos[0]) % @height][(x + pos[1]) % @width].alive?
      sum
    end
  end

  def alive_cells
    @world.inject(0) { |sum, row|
      sum += row.count { |cell|
        :alive == cell.state
      }
      sum
    }
  end

  def draw(window)
    @world.each { |row|
      row.each { |cell| cell.draw window } }
  end

  def to_s
    @world.each { |row|
      row.each { |cell| print cell.alive? ? '0' : '.' }
      puts '\n'
    }
  end

end