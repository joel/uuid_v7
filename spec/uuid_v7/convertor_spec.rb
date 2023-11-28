# frozen_string_literal: true

module UuidV7
  RSpec.describe Convertor do
    let(:uuid)   { "018c160f-5adc-79ad-932b-3d25a62de3d1" }
    let(:base58) { "c5HpnewpE1DtZgL7tir1S" }
    let(:int)    { 2_056_596_985_533_698_964_084_530_851_032_720_337 }

    it "converts to int" do
      expect(described_class.uuid_to_int(uuid)).to eql(int)
    end

    # it "converts to base58" do
    #   expect(described_class.uuid_to_base58(uuid)).to match(/\w{21}/)
    # end

    # it "converts to base58" do
    #   expect(described_class.base58_to_int(base58)).to match(/\w{21}/)
    # end
  end
end
