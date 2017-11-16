require 'clock_store'

describe ClockStore do
  let(:clock) { double :clock }
  before { ClockStore.clear_clocks}

  describe "#clocks" do
    it 'starts with an empty array' do
      expect(ClockStore.clocks).to be_empty
    end
  end

  describe "#add_clock" do
    it 'should add a clock to clocks' do
      expect{ClockStore.add_clock(clock)}.to change{ClockStore.clocks.length}.by 1
    end
  end

  describe "#clear_clocks" do
    it 'should empty array of clocks' do
      ClockStore.add_clock(clock)
      ClockStore.clear_clocks
      expect(ClockStore.clocks).to be_empty
    end
  end


end
