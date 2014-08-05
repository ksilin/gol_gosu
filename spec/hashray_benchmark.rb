require 'benchmark'

class Hashray

  def initialize
    @data = Hash.new { |h, k| h[k] = [] }
  end

  def []=(index, value)
    @data[index] = value
  end

  def [](index)
    @data[index]
  end
end

iterations = 10

[10, 100, 1000].each do |n|

  hashray = Hashray.new
  (0...n).each { |index| hashray[index] = Array.new(n, 1) }

  ary = (0...n).map { Array.new(n, 1) }

  #perhaps it's the ad-hoc array creation?
  prepared_indices = (0...n).each_with_object([]) { |x, ind|
    (0...n).each { |y|
      ind << [x, y]
    }
  }

  hash = {}
  (0...n).each { |x|
    (0...n).each { |y|
      hash[[x, y]] = 1
    }
  }

  Benchmark.bmbm(20) do |bm|
    bm.report('hash of arrays:') do
      iterations.times do
        (0...n).each { |x|
          (0...n).each { |y|
            v = hashray[x][y]
          }
        }
      end
    end

    bm.report('array of arrays:') do
      iterations.times do
        (0...n).each { |x|
          (0...n).each { |y|
            v = ary[x][y]
          }
        }
      end
    end

    bm.report('flat hash:') do
      iterations.times do
        prepared_indices.each { |i|
          v = hash[i]
        }
      end
    end
  end
end