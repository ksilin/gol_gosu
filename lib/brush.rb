class Brush

  BRUSHES = {
  :glider => [[:die, :live, :live],
            [:live, :live, :die],
            [:die, :live, :die]],

  :life => [[:live, :live, :live],
          [:live, :live, :live],
          [:live, :live, :live]],

  :death => [[:die, :die, :die],
           [:die, :die, :die],
           [:die, :die, :die]]
  }

  attr_accessor :brush_name

  def initialize(brush_name = :life)
    @brush_name = brush_name
  end

  def next
    keys = BRUSHES.keys
    @brush_name = keys[(keys.index(@brush_name) + 1)%keys.size]
    p "switching to #{@brush_name}"
  end

  def brush
    BRUSHES[@brush_name]
  end

end