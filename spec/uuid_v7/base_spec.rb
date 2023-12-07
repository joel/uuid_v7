# frozen_string_literal: true

module UuidV7
  RSpec.describe Base do
    let(:uuid_v7_regex) { /\A\h{8}-\h{4}-7\h{3}-[89ab]\h{3}-\h{12}\z/ }
    let(:record_class)  { Keyboard }

    it "generates an uuid" do
      expect(record_class.new.uuid).to match(uuid_v7_regex)
    end

    it "doesn't override a UUID set in the initializer attributes" do
      override_uuid = SecureRandom.uuid_v7
      instance      = record_class.new(uuid: override_uuid)

      expect(instance.uuid).to eql(override_uuid)
    end
  end
end
