describe Clock do
  subject(:clock) { described_class.new }
  describe "#id" do
    it "has a unique id" do
      allow(SecureRandom).to receive(:uuid).and_return('aaaaaaa-bbbb-cccc-dddd-111111111111')
      expect(clock.id).to eq("aaaaaaa-bbbb-cccc-dddd-111111111111")
    end
  end

  describe "#time" do
    it "returns the clocks time" do
      allow(Time).to receive(:now).and_return('2017-11-16 10:45:18 +0000')
      expect(clock.time).to eq('2017-11-16 10:45:18 +0000')
    end
  end
end
