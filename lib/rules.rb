class Rules

  # rules in B[]S[] format
  # default rule: B3S23

  RULES = { :original => { :dead => [3], :alive => [2, 3] },
            :highlife => { :dead => [3, 6], :alive => [2, 3] },
            :seeds => { :dead => [2], :alive => [] },
            :live_free_or_die => { :dead => [2], :alive => [0] },
            :dotlife => { :dead => [3], :alive => [0, 2, 3] },
            :mazectric => { :dead => [3], :alive => [1, 2, 3, 4] },
            :coral => { :dead => [3], :alive => [4, 5, 6, 7, 8] },
            :maze => { :dead => [3], :alive => [1, 2, 3, 4, 5] },
  }

  ODD_RULES = {
      :gnarl => { :dead => [1], :alive => [1] },
      :replicator => { :dead => [1, 3, 5, 7], :alive => [1, 3, 5, 7] },
      :fredkin => { :dead => [1, 3, 5, 7], :alive => [0, 2, 4, 6, 8] },
  }

  def initialize(rule = :original)
    @rule = RULES[rule]
  end

  def next
    v = RULES.values
    @rule = v[(v.index(@rule) + 1)%v.size]
    p "switching to #{RULES.key(@rule)}"
  end

  def apply(cell, alive_neighbors)
    live_or_die = next_state(cell.state, alive_neighbors)
    cell.next_state(live_or_die)
  end

  def next_state(state, alive_neighbors)
    @rule[state].include?(alive_neighbors) ? :alive : :dead
  end
end