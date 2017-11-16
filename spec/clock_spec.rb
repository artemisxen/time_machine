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
    it "returns the clocks time" do
      expect(clock.time).to eq('2017-11-16 10:45:18 +0000')
    end
  end

  describe "#json" do
    it "gives json format to the object" do
      expect(clock.as_json).to eq ({"id": "aaaaaaa-bbbb-cccc-dddd-111111111111", "time": "2017-11-16 10:45:18 +0000"})
    end
  end
end
