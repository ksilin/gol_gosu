require 'rspec'
require 'spec_helper'
require 'world'

describe 'Initialization' do

  it 'should initialize random cells' do
    world = World.new(6, 6)
    p world.to_s
    world.update
    p world.to_s
    world.update
    p world.to_s
    world.update
    p world.to_s
  end

  it 'should apply rules correctly' do
    world = World.new(3, 3)
    world.kill_all
    world.update
    world.to_s
    # crazy y, x coords
    world[0][0].live
    world[1][0].live
    world[2][0].live
    world.update
    world.to_s
    world.update
    world.to_s
  end

  it 'should calcultate neighbors correctly' do
    world = World.new(3, 3)
    world.kill_all
    world.update
    world.to_s
    # crazy y, x coords
    world[1][1].live
    world.update

    p world.neighborhood(1, 1)

    world.to_s
    world.update
    world.to_s
  end

  it 'should rotate the array' do
    p World::GLIDER.transpose.map &:reverse
  end

end