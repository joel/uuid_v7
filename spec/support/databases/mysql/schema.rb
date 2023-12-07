# frozen_string_literal: true

ActiveRecord::Schema.define do
  self.verbose = ENV.fetch("DEBUG", nil)

  create_table :keyboards, id: false do |table|
    table.binary :uuid, limit: 16, null: false, index: { unique: true }, primary_key: true
    table.string :name
    table.timestamps
  end

  create_table :keys, id: false do |table|
    table.binary :uuid, limit: 16, null: false, index: { unique: true }, primary_key: true
    table.string :letter

    table.binary :keyboard_id, null: false, limit: 16
    table.foreign_key :keyboards, column: :keyboard_id, primary_key: "uuid"
    table.index :keyboard_id

    # NOTE: If the primary key is not set to `id`, then the following error will occur:
    # ActiveRecord::StatementInvalid:
    # Mysql2::Error: Failed to add the foreign key constraint. Missing column 'id' for constraint 'fk_rails_5e5a682abd' in the referenced table 'keyboards'
    # table.references :keyboard, foreign_key: true, index: true, null: false, type: :binary, limit: 16

    table.timestamps
  end

  create_table :apples, id: false do |table|
    table.binary :uuid_ref, limit: 16, null: true, index: { unique: true }
  end
end
