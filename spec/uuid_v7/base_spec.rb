# frozen_string_literal: true

module UuidV7
  ActiveRecord::Schema.define do
    self.verbose = false

    create_table :bars do |t|
      t.string :uuid, index: { unique: true }
      t.string :name
      t.timestamps
    end
  end

  class Bar < ActiveRecord::Base
  end

  RSpec.describe Base do
    before { Bar.include(described_class) }

    it "generates an uid" do
      expect(Bar.new.uuid).to match(/\w{8}-\w{4}-\w{4}-\w{4}-\w{12}/)
    end

    it "does not override an existing uid" do
      expect(Bar.new.uuid_to_int.to_s).to match(/\d{37}/)
    end
  end
end
