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
end