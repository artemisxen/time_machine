require 'clock'

describe Clock do
  it 'starts with an empty array' do
    expect(Clock.clocks).to be_empty
  end
end
