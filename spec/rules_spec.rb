require 'rspec'
require 'rules'

describe 'My behaviour' do

  let(:rules){Rules.new}

  it 'should apply underpopulation rule' do
    expect(rules.next_state(:alive, 0)).to be :dead
    expect(rules.next_state(:alive, 1)).to be :dead
  end

  it 'should apply overcrowding rule' do
    expect(rules.next_state(:alive, 4)).to be :dead
    expect(rules.next_state(:alive, 13462346)).to be :dead
  end

  it 'should apply revival rule' do
    (0..2).each { |x|
      expect(rules.next_state(:dead, x)).to be :dead
    }
    expect(rules.next_state(:dead, 3)).to be :alive
    (4..10).each { |x|
      expect(rules.next_state(:dead, x)).to be :dead
    }
  end

  it 'should apply survival rule' do
    expect(rules.next_state(:alive, 2)).to be :alive
    expect(rules.next_state(:alive, 3)).to be :alive
  end

end