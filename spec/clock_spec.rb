require 'clock'

describe Clock do
  before { Clock.clear_clocks}
  it 'starts with an empty array' do
    expect(Clock.clocks).to be_empty
  end

  it 'should add a clock to clocks' do
    expect{Clock.add_clock}.to change{Clock.clocks.length}.by 1
  end
end
