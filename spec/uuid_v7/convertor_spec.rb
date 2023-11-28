# frozen_string_literal: true

module UuidV7
  RSpec.describe Convertor do
    let(:uuid)   { "018c160f-5adc-79ad-932b-3d25a62de3d1" }
    let(:base58) { "c5HpnewpE1DtZgL7tir1S" }

    it "converts to base58" do
      expect(described_class.to_base58(uuid)).to match(/\w{21}/)
    end

    it "converts to base58" do
      expect(described_class.to_base58(uuid)).to match(/\w{21}/)
    end
  end
end
