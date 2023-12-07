# frozen_string_literal: true

RSpec.describe "ActiveRecord CRUD" do
  let(:uuid) { "018c16a5-334d-71cc-890e-816a036111f8" }
  let(:record)       { record_class.new(uuid:, name: "ISO British/Irish") }
  let(:record_class) { Keyboard }

  describe "create" do
    it "creates a record with a UUID" do
      expect { record.save }.to change(record_class, :count).by(1)
    end
  end

  context "with SQL injection" do
    it "can't be used to inject SQL using .where" do
      case ENV.fetch("DATABASE", nil)
      when "sqlite3"
        expect do
          record_class.where(uuid: "' OR ''='").take
        end.to raise_error(UuidV7::Types::InvalidUUID, "' OR ''=' is not a valid UUID")
      when "mysql"
        expect do
          record_class.where(uuid: "' OR ''='").take
        end.to raise_error(ActiveRecord::StatementInvalid, "UuidV7::Types::InvalidUUID: ' OR ''=' is not a valid UUID")
      else
        raise "Unknown database: #{ENV.fetch("DATABASE", nil)}"
      end
    end

    it "can't be used to inject SQL using .find_by" do
      expect do
        record_class.find_by(uuid: "' OR ''='")
      end.to raise_error(UuidV7::Types::InvalidUUID)
    end

    it "can't be used to inject SQL while creating" do
      expect do
        record_class.create!(uuid: "' OR ''='")
      end.to raise_error(UuidV7::Types::InvalidUUID)
    end
  end

  context "with a persisted record" do
    before { record.save }

    it "stores a binary value in the database" do
      first_row      = record_class.connection.execute("SELECT uuid FROM keyboards").to_a[0]
      raw_uuid_value = first_row[0] # "uuid"

      expect(raw_uuid_value.encoding).to eql(Encoding::ASCII_8BIT)
    end

    context "with passing over the id of the foreign key" do
      it "creates a record with a UUID" do
        key = Key.new(keyboard: record)
        expect { key.save }.to change(Key, :count).by(1)
      end
    end

    describe "read" do
      it "finds a record by UUID .find_by" do
        expect(record_class.find_by(uuid:)).to eql(record)
      end

      it "finds a record by UUID .where" do
        expect(record_class.where(uuid:).take).to eql(record)
      end
    end

    describe "update" do
      it "updates a record by UUID" do
        record.update(uuid: SecureRandom.uuid_v7)

        expect(record_class.find_by(uuid:)).to be_nil
      end
    end

    describe "delete" do
      it "deletes a record by UUID" do
        record.destroy

        expect(record_class.find_by(uuid:)).to be_nil
      end
    end
  end
end
