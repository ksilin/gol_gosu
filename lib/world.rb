require 'hasu'
Hasu.load 'cell.rb'

class World
  include Enumerable

  attr_reader :width, :height, :rules, :generations

  WIDTH = 100
  HEIGHT = 60

  # rules in B[]S[] format
  # default rule: B3S23

  RULES = {:original => [[3], [2, 3]],
           :highlife => [[3, 6], [2, 3]],
           :seeds => [[2],[]],
           :live_free_or_die => [[2],[0]],
           :dotlife => [[3],[0, 2, 3]],
           :mazectric => [[3],[1, 2, 3, 4]],
           :coral => [[3], [4, 5, 6, 7, 8]],
           :maze => [[3], [1, 2, 3, 4, 5]],
  }

  ODD_RULES = {
      :gnarl => [[1],[1]],
      :replicator => [[1, 3, 5, 7],[1, 3, 5, 7]],
      :fredkin => [[1, 3, 5, 7], [0, 2, 4, 6, 8]],
  }


  def initialize( width = WIDTH, height = HEIGHT, rules = [[3], [4, 5, 6, 7, 8]])
    @width = width
    @height = height
    @rules = rules
    @generations = 0

    @cells = Array.new(width) { |x| Array.new(height) { |y| Cell.new(x, y) } }
  end

  def next_rule
    new_rule_name = RULES.keys.sample
    p "switching to #{new_rule_name}"
    @rules = RULES[new_rule_name]
  end


  def revive_around(x, y)
    neighborhood.each do |pos|
      @cells[(x/@y_factor + pos[0]) % @width][(y/@x_factor + pos[1]) % @height].live
    end
  end

  def[](index)
    @cells[index]
  end

  def kill_all
    each &:die
  end

  def revive_all
    each &:live
  end

  def update
    @generations += 1

    @cells.each_with_index { |col, x|
      col.each_with_index { |cell, y|
    #each_with_index {|cell, x, y|
        neighbors_count = alive_neighbours(x, y)
        case cell.state
          when :alive
            cell.die unless rules[1].include? neighbors_count
          when :dead
            cell.live if rules[0].include? neighbors_count
        end
      }
    }
    each &:switch_to_next_state
  end

  def each(&block)
    @cells.each { |row|
      row.each { |cell|
        block.call cell }
    }
  end

  def each_with_index(&block)
    @cells.each_with_index { |row, x|
      row.each { |cell, y|
        block.call cell, x, y }
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

    @x_factor = window.width/@width
    @y_factor = window.height/@height

    each{|cell| cell.draw window, @x_factor, @y_factor}
  end

  def to_s
    @cells.each { |col|
      col.each { |cell| print cell.alive? ? '0' : '.' }
      puts '\n'
    }
  end

end