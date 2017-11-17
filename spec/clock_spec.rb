require 'clock'

describe Clock do
  subject(:clock) { described_class.new }

  before do
    allow(SecureRandom).to receive(:uuid).and_return('aaaaaaa-bbbb-cccc-dddd-111111111111')
    allow(Time).to receive(:now).and_return('2017-11-16 10:45:18 +0000')
  end

  describe "#id" do
    it "has a unique id" do
      expect(clock.id).to eq("aaaaaaa-bbbb-cccc-dddd-111111111111")
    end
  end

  describe "#time" do
    context 'there is no fake time' do
      it "should return the current time" do
        expect(clock.time).to eq('2017-11-16 10:45:18 +0000')
      end
    end

    context 'fake_time and counter > 1' do
      it "should return the faked time" do
        clock.set_fake_time('2017-11-16 00:00:00 +0000', 1)
        expect(clock.time).to eq('2017-11-16 00:00:00 +0000')
      end
    end

    context 'fake_time and counter == 0' do
      it 'should not change the time to fake_time if counter == 0' do
        clock.set_fake_time('2017-11-16 00:00:00 +0000', 0)
        expect(clock.time).to eq('2017-11-16 10:45:18 +0000')
      end
    end
  end

  describe "#current_time" do
    it "returns the clocks time" do
      clock.current_time
      expect(clock.time).to eq('2017-11-16 10:45:18 +0000')
    end
  end

  describe "#json" do
    it "gives json format to the object" do
      expect(clock.as_json).to eq ({"id": "aaaaaaa-bbbb-cccc-dddd-111111111111", "time": "2017-11-16 10:45:18 +0000", "counter": 0})
    end
  end

  describe "#set_fake_time" do
    it "returns a specified time" do
      clock.set_fake_time('2017-11-16T00:00:00:00+0000', 1)
      expect(clock.fake_time).to eq '2017-11-16T00:00:00:00+0000'
    end

    it "should set the counter to according to the param received" do
      clock.set_fake_time('2017-11-16T00:00:00:00+0000', 1)
      expect(clock.counter).to eq 1
    end

  end

  describe "#reduce_counter" do
    it "lowers counter by 1" do
      clock.set_fake_time('2017-11-16T00:00:00:00+0000', 1)
      clock.reduce_counter
      expect(clock.counter).to eq 0
    end

    it "should not reduce counter if counter is 0" do
      expect{clock.reduce_counter}.to_not change{clock.counter}
    end
  end
end
