# frozen_string_literal: true

module UuidV7
  RSpec.describe Converter do
    let(:uuid)   { "018c16a5-334d-71cc-890e-816a036111f8" }
    let(:base58) { "c5HAaYUinPPhJu6DhdZvA" }
    let(:int)    { 2_056_608_857_515_247_120_686_359_903_918_428_664 }

    it "converts int to UUID" do
      expect(described_class.int_to_uuid(int)).to eql(uuid)
    end

    it "converts UUID to int" do
      expect(described_class.uuid_to_int(uuid)).to eql(int)
    end

    it "converts base58 to UUID" do
      expect(described_class.base58_to_uuid(base58)).to eql(uuid)
    end

    it "converts UUID to base58" do
      expect(described_class.uuid_to_base58(uuid)).to eql(base58)
    end
  end
end
