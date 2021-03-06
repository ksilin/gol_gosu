require_relative 'cell.rb'
require_relative 'brush.rb'
require_relative 'rules.rb'

class World
  include Enumerable

  attr_reader :width, :height, :rules, :generations

  WIDTH = 40
  HEIGHT = 120

  # central cell with [0, 0] offset excluded
  NEIGHBORHOOD_OFFSETS = [[-1, 0], [1, 0], # sides
                          [-1, 1], [0, 1], [1, 1], # above
                          [-1, -1], [0, -1], [1, -1]] # below

  def initialize(width = WIDTH, height = HEIGHT, rules = :original)
    @width = width
    @height = height
    @running = true
    @rules = Rules.new(rules)
    @generations = 0
    @brush = Brush.new(:glider)
    @cells = Array.new(width) { |x|
      Array.new(height) { |y|
        Cell.new(x, y, random_state)
      }
    }
  end

  def update
    return unless @running
    @generations += 1
    each_with_indices { |cell, x, y|
      next_state = @rules.next_state(cell.state, alive_neighbours(x, y))
      cell.next_state = next_state
    }
    each &:switch_to_next_state
  end

  def each(&block)
    @cells.each { |col|
      col.each { |cell|
        block.call cell
      }
    }
  end

  def each_with_indices(&block)
    @cells.each_with_index { |col, x|
      col.each_with_index { |cell, y|
        block.call cell, x, y
      }
    }
  end

  def alive_neighbours(x, y)
    NEIGHBORHOOD_OFFSETS.count do |pos|
      @cells[(x + pos[0]) % width][(y + pos[1]) % height].alive?
    end
  end

  def alive_cells
    count{ |cell| :alive == cell.state }
  end

  def neighborhood(x=0, y=0)
    (x-1..x+1).to_a.reduce([]) { |neighbors, x1|
      (y-1..y+1).to_a.each { |y1| neighbors << [x1, y1] }
      neighbors
    }
  end

  def random_state
    rand > 0.5 ? :alive : :dead
  end

  def next_rule
    @rules.next
  end

  # TODO - pull all the brush stuff up
  def add_glider(x, y)
    neighborhood.each do |pos|
      x_index = (x + pos[0]) % @width
      y_index = (y + pos[1]) % @height
      cell = @cells[x_index][y_index]
      # TODO rotate the brush
      #GLIDER = GLIDER.transpose.map &:reverse
      cell.next_state = @brush.brush[pos[0]][pos[1]]
      cell.switch_to_next_state
    end
  end

  def switch_brush
    @brush.next
  end

  def kill_all
    $stderr.puts 'killing everybody'
    each { |c| c.next_state = :dead }
    each &:switch_to_next_state
  end

  def revive_all
    $stderr.puts 'reviving everybody'
    each { |c| c.next_state = :alive }
    each &:switch_to_next_state
  end

# ௵,  ࿋, ℺, ▉, ■, ☀, ☺
  def to_s

    alive_ansi = "\033[1;32mX\033[m"
    dead_ansi = ' '

    @cells.reduce('') { |columns, col|
      columns + col.reduce('') { |row, cell|
        row + (cell.alive? ? alive_ansi : dead_ansi) } + "\n"
    }
  end

  def clear
    print "\033[2J" # clearing the whole screen is more practical than deleting lines with "\r\e[A\e[K"
  end

  # TODO - should be a gem API method
  def self.ascii_demo

    width = `tput cols`.to_i
    height = `tput lines`.to_i

    puts "world size #{width}x#{height}"

    world = World.new(height, width)
    loop do
      world.update
      world.clear
      puts world.to_s
      sleep 0.1
    end
  end

  def toggle_pause
    @running = !@running
  end

end