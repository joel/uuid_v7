# frozen_string_literal: true

module UuidV7
  RSpec.describe Main do
    subject(:foo) { described_class.new }
    describe "#uuid_v7" do
      context "when all is good" do
        let(:input) { "foo" }
        let(:result) { "foo" }

        it do
          expect(foo.uuid_v7(input)).to eql(result)
        end
      end
    end
  end
end
