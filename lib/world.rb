require 'hasu'
#Hasu.load 'cell.rb'
require_relative 'cell.rb'
require_relative 'brush.rb'

class World
  include Enumerable

  attr_reader :width, :height, :rules, :generations

  WIDTH = 100
  HEIGHT = 60

  # rules in B[]S[] format
  # default rule: B3S23

  RULES = {:original => [[3], [2, 3]],
           :highlife => [[3, 6], [2, 3]],
           :seeds => [[2], []],
           :live_free_or_die => [[2], [0]],
           :dotlife => [[3], [0, 2, 3]],
           :mazectric => [[3], [1, 2, 3, 4]],
           :coral => [[3], [4, 5, 6, 7, 8]],
           :maze => [[3], [1, 2, 3, 4, 5]],
  }

  ODD_RULES = {
      :gnarl => [[1], [1]],
      :replicator => [[1, 3, 5, 7], [1, 3, 5, 7]],
      :fredkin => [[1, 3, 5, 7], [0, 2, 4, 6, 8]],
  }

  def initialize(width = WIDTH, height = HEIGHT, rules = :original)
    @width = width
    @height = height
    @running = true
    @rules = rules
    @generations = 0
    @brush = Brush.new(:glider)
    @cells = Hash.new{|h, k| h[k] = []}

    (0...width).each{|x|
      (0...height).each{|y|
        @cells[x][y] = Cell.new(x, y)
      }
    }
    p @cells.size
    p @cells[0]
    p @cells[0].size
    #@cells = Array.new(width) { |x| Array.new(height) { |y| Cell.new(x, y) } }
  end

  def next_rule
    @rules = RULES.keys[(RULES.keys.index(@rules) + 1)%RULES.keys.size]
    p "switching to #{@rules}"
  end


  def draw_glider(x, y)
    neighborhood.each do |pos|
      x_index = ((x/@y_factor + pos[0]) % @width).round
      y_index =((y/@x_factor + pos[1]) % @height).round

      cell = @cells[x_index][y_index]
      # TODO rotate the brush
      #GLIDER = GLIDER.transpose.map &:reverse
      cell.send @brush.brush[pos[0]][pos[1]]
    end
  end

  def switch_brush
    @brush.next
  end

  def [](index)
    @cells[index]
  end

  def kill_all
    each &:die
  end

  def revive_all
    each &:live
  end

  def update
    return unless @running

    @generations += 1

    each_with_indices { |cell, x, y|
      neighbors_count = alive_neighbours(x, y)
      case cell.state
        when :alive
          cell.die unless RULES[@rules][1].include? neighbors_count
        when :dead
          cell.live if RULES[@rules][0].include? neighbors_count
      end
    }
    each &:switch_to_next_state
  end

  def each(&block)
    @cells.each { |col|
      col[1].each { |cell|
        #p "executing block on #{cell}"
        block.call cell }
    }
  end

  def each_with_indices(&block)
    @cells.each_with_index { |col, x|
      col[1].each_with_index { |cell, y|
        #p "executing block on #{cell} at #{x}, #{y}"
        block.call cell, x, y
      }
    }
  end

  def alive_neighbours(x, y)
    [[-1, 0], [1, 0], # sides
     [-1, 1], [0, 1], [1, 1], # over
     [-1, -1], [0, -1], [1, -1] # under
    ].inject(0) do |sum, pos|
      sum +=1 if @cells[(x + pos[0]) % width][(y + pos[1]) % @height].alive?
      sum
    end
  end

  def alive_cells
    inject(0) { |sum, cell|
      sum +=1 if :alive == cell.state
      sum
    }
  end

  def neighborhood(x=0, y=0)
    (x-1..x+1).to_a.inject([]) { |neighbors, x1|
      (y-1..y+1).to_a.each { |y1| neighbors << [x1, y1] }
      neighbors
    }
  end

  def draw(window)

    @x_factor = window.width/@width
    @y_factor = window.height/@height

    each { |cell| cell.draw window, @x_factor, @y_factor }
  end

  def to_s
    @cells.each { |col|
      col[1].each { |cell| print cell.alive? ? '0' : '.' }
      puts '\n'
    }
  end

  def toggle_pause
    @running = !@running
  end

end