class Rules

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

  def initialize(rule = :original)
    @rule = rule
  end

  def next
    @rule = RULES.keys[(RULES.keys.index(@rule) + 1)%RULES.keys.size]
    p "switching to #{@rule}"
  end

  def apply(cell, alive_neighbors)
    case cell.state
      when :alive
        cell.die unless RULES[@rule][1].include? alive_neighbors
      when :dead
        cell.live if RULES[@rule][0].include? alive_neighbors
    end
  end
end