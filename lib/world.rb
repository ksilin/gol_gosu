require 'hasu'
Hasu.load 'cell.rb'

class World
  include Enumerable

  attr_reader :width, :height, :rules, :generations

  WIDTH = 100
  HEIGHT = 60

  # default rules B3S23
  # Any live cell with fewer than two live neighbours dies, as if caused by under-population.
  # Any live cell with two or three live neighbours lives on to the next generation.
  # Any live cell with more than three live neighbours dies, as if by overcrowding.
  # Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction.
  #[[3, 6, 7, 8], [3, 4, 6, 7, 8]]
  [[3], [1, 2, 3, 4, 5]]
  [[3], [4, 5, 6, 7, 8]]

  def initialize(window, width = WIDTH, height = HEIGHT, rules = [[1, 3], [2, 3, 4]])
    @window = window
    @width = width
    @height = height
    @rules = rules
    @generations = 0

    @x_factor = @width/window.width
    @y_factor = @height/window.height
    @buffer1 = Array.new(height) { |y| Array.new(width) { |x| Cell.new(x*5, y*5) } }
    @world = @buffer1
  end

  def revive_around(x, y)
    neighborhood.each do |pos|
      @world[(y + pos[0]) % @height][(x + pos[1]) % @width].live
    end
  end

  def kill_all
    each &:die
  end

  def revive_all
    each &:live
  end

  def update
    @generations += 1

    @world.each_with_index { |row, y|
      row.each_with_index { |cell, x|
    #each_with_index {|cell, x, y|
        neighbors = alive_neighbours(x, y)
        case cell.state
          when :alive
            cell.die unless rules[1].include? neighbors
          when :dead
            cell.live if rules[0].include? neighbors
        end
      }
    }

    each &:switch_to_next_state

    if @window.button_down? Gosu::MsLeft
      revive_around((@window.mouse_x/5), (@window.mouse_y/5))
    end
  end

  def each(&block)
    @world.each { |row|
      row.each { |cell|
        block.call cell
      }
    }
  end

  def each_with_index(&block)
    @world.each_with_index { |row, y|
      row.each { |cell, x|
        block.call cell, x, y
      }
    }
  end

  def alive_neighbours(x, y)
    [[-1, 0], [1, 0], # sides
     [-1, 1], [0, 1], [1, 1], # over
     [-1, -1], [0, -1], [1, -1] # under
    ].inject(0) do |sum, pos|
      sum +=1 if @world[(x + pos[0]) % @height][(y + pos[1]) % @width].alive?
      sum
    end
  end

  def alive_cells
    inject(0){|sum, cell|
       sum +=1 if :alive == cell.state
      sum
    }
  end

  def neighborhood(x=0, y=0)
    (x-1..x+1).to_a.inject([]){ |neighbors, x1|
      (y-1..y+1).to_a.each{ |y1| neighbors << [x1, y1]}
      neighbors
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