# frozen_string_literal: true

RSpec.describe "Migration UUID" do
  subject(:migration) do
    Class.new do
      include UuidV7::Patches::Mysql::FxMigration
    end.new
  end

  describe "#populate_uuid_field" do
    context "with records" do
      before { 10.times { Apple.create! } }

      context "with uuid_ref column" do
        before do
          allow(migration).to receive(:column_exists?).and_return(true)
        end

        it "populates the UUID value to the records" do
          expect do
            migration.populate_uuid_field(table_name: :apples, column_name: :uuid_ref)
          end.to change {
            Apple.where(uuid_ref: nil).count
          }.from(10).to(0)

          expect(migration).to have_received(:column_exists?).with(:apples, :uuid_ref).once
        end

        context "with a populated UUID values" do
          before do
            migration.populate_uuid_field(table_name: :apples, column_name: :uuid_ref)
          end

          it "has a conform UUID" do
            Apple.all.each do |apple|
              expect(apple.uuid_ref).to match(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)
            end
          end
        end
      end
    end
  end
end
