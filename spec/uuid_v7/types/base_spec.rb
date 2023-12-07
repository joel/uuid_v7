# frozen_string_literal: true

module UuidV7
  module Types
    RSpec.describe Base do
      subject(:base_type) { described_class.new }

      describe "#serialize" do
        context "with a normailized UUID" do
          let(:uuid)          { "018c245b-052b-732d-b887-bbdfb1435ea6" }
          let(:undashed_uuid) { uuid.delete("-") }

          it "serialize into Data object" do
            expect(base_type.serialize(uuid)).is_a?(Data)
          end

          it "stripes the dashes" do
            expect(base_type.serialize(uuid).to_s).to eq(undashed_uuid)
          end

          it "has the right encoding" do
            expect(uuid.encoding.to_s).to eq("UTF-8")
          end

          it "converts to binary" do
            expect(base_type.serialize(uuid).to_s.encoding.to_s).to eq("ASCII-8BIT")
          end

          it "has the right size" do
            expect(base_type.serialize(uuid).to_s.length).to eq(32)
          end
        end

        context "with none conform UUID" do
          let(:uuid) { "none-conform-uuid" }

          it "raise an exception" do
            expect do
              base_type.serialize(uuid)
            end.to raise_error(UuidV7::Types::InvalidUUID)
          end
        end
      end
    end
  end
end
