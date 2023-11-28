# frozen_string_literal: true

module UuidV7
  RSpec.describe Convertor do
    let(:uuid)   { "018c160f-5adc-79ad-932b-3d25a62de3d1" }
    let(:base58) { "c5HpnewpE1DtZgL7tir1S" }
    let(:int)    { 2_056_596_985_533_698_964_084_530_851_032_720_337 }

    it "converts uuid to int" do
      expect(described_class.uuid_to_int(uuid)).to eql(int)
    end

    it "converts uuid to base58" do
      expect(described_class.uuid_to_base58(uuid)).to match(/\w{21}/)
    end

    it "converts base58 to int" do
      expect(described_class.base58_to_int(base58).to_s).to match(/\d{37}/)
    end

    it "converts int to uuid" do
      expect(described_class.int_to_uuid(int)).to match(/\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/)
    end
  end
end
