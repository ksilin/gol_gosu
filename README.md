# Golgosu - A Game of Life implementation in Ruby

[![Code Climate](https://codeclimate.com/github/ksilin/gol_gosu.png)](https://codeclimate.com/github/ksilin/gol_gosu)

The game has two visualizations:


#### Gosu-based visualization. With colors and electrolytes! 

* Draw gliders on the screen with a mouse click. 

* Change the rules by pressing <kbd>Space</kbd>

In addition to the classic B3S23 rule, there are lots of different rulesets, each generating distinct patterns and behaviours. Have fun exploring. 

* Reset the world by pressing <kbd>R</kbd>
* Pause/resume by pressing <kbd>P</kbd>
* Switch 'brushes' (instead of drawing gliders, you can kill or resurrect cells) with <kbd>B</kbd>

In order to start the gosu visualization, execute `ruby lib/golgosu.rb` in your terminal.


#### Terminal-based ASCII/ANSI visualization. 

Can be started via a REPL like irb or pry:
 
        irb> load 'lib/world.rb'
        # => true
        irb> World.ascii_demo

This implementation has been tested on Linux only. It will probably work on Mac without or with only minor adaptations. It will probably not work on Windows. 

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
