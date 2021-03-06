require 'rspec'
require 'spec_helper'
require 'world'

describe 'Initialization' do

  it 'should initialize random cells' do
    world = World.new(6, 6)
    puts world.to_s + "\n"
    world.update
    puts world.to_s + "\n"
    world.update
    puts world.to_s + "\n"
    world.update
    puts world.to_s + "\n"
  end

  it 'should apply rules correctly' do
    world = World.new(3, 3)
    world.kill_all
    world.update
    puts world.to_s + "\n"
    world[0][0].next_state = :alive
    world[0][1].next_state = :alive
    world[0][2].next_state = :alive
    world.update
    puts world.to_s + "\n"
    world.update
    puts world.to_s + "\n"
  end

  it 'should calculate neighbors correctly' do
    world = World.new(3, 3)
    world.kill_all
    world.update
    puts world.to_s + "\n"
    world[1][1].next_state = :alive
    world.update

    puts world.to_s  + "\n"
    world.update
    puts world.to_s + "\n"
  end

  it 'should rotate the array' do
    p [[:top_left, :top_right],
       [:bottom_left, :bottom_right]].transpose.map &:reverse
  end

end