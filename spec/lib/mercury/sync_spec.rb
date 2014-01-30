require 'rspec'
require 'mercury/sync'

describe Mercury::Sync do

  describe '#open' do
    it 'returns an open Mercury::Sync instance' do
      expect(Mercury::Sync.open).to be_a Mercury::Sync
    end
  end

  it 'should do something' do

    true.should == false
  end
end
