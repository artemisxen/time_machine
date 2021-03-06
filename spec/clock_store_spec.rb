require 'clock_store'

describe ClockStore do
  let(:clock) { double :clock, id: 1, as_json: { time: "12.00", id: 1} }
  before { ClockStore.clear}

  describe "#clocks" do
    it 'starts with an empty array' do
      expect(ClockStore.clocks).to be_empty
    end
  end

  describe "#add" do
    it 'should add a clock to clocks' do
      expect{ClockStore.add(clock)}.to change{ClockStore.clocks.length}.by 1
    end
  end

  describe "#clear_clocks" do
    it 'should empty array of clocks' do
      ClockStore.add(clock)
      ClockStore.clear
      expect(ClockStore.clocks).to be_empty
    end
  end

  describe "#find_clock" do
    it 'should find a clock from the clocks' do
      ClockStore.add(clock)
      expect(ClockStore.find(1)).to eq clock
    end
  end

  describe "#delete_clock" do
    it 'should delete a clock from clocks' do
      ClockStore.add(clock)
      expect{ClockStore.delete(1)}.to change{ClockStore.clocks.length}.by -1
    end
  end

  describe "#as_json" do
    it 'should display clocks as json' do
      ClockStore.add(clock)
      expect(ClockStore.as_json).to eq [{ time: "12.00", id: 1}]
    end
  end

end
