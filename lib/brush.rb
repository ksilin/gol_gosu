class Brush

  BRUSHES = {
  :glider => [[:dead, :alive, :alive],
            [:alive, :alive, :dead],
            [:dead, :alive, :dead]],

  :life => [[:alive, :alive, :alive],
          [:alive, :alive, :alive],
          [:alive, :alive, :alive]],

  :death => [[:dead, :dead, :dead],
           [:dead, :dead, :dead],
           [:dead, :dead, :dead]]
  }

  attr_accessor :brush_name

  def initialize(brush_name = :life)
    @brush_name = brush_name
  end

  def next
    keys = BRUSHES.keys
    @brush_name = keys[(keys.index(@brush_name) + 1)%keys.size]
    $stderr.puts "switching to #{@brush_name}"
  end

  def brush
    BRUSHES[@brush_name]
  end

end