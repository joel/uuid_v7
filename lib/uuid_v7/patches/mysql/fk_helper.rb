# frozen_string_literal: true

module Alliantist
  module Migrations
    module UuidFkHelper
      # update_fk_uuid_between_table(parent_table_name: :engines, child_table_name: :pistons)
      def update_fk_uuid_between_table(parent_table_name:, child_table_name:)
        table_name_parent = parent_table_name.to_s.to_sym # :engines
        table_name_child  = child_table_name.to_s.to_sym  # :pistons
        foreign_key_id    = :"#{table_name_parent.to_s.singularize}_id"   # :engine_id
        foreign_key_uuid  = :"#{table_name_parent.to_s.singularize}_uuid" # :engine_uuid

        add_column table_name_child, foreign_key_uuid, :binary, limit: 16, null: true # :pistons, :engine_uuid

        # Update the foreign_key in child table
        connection.execute <<-SQL.squish
          UPDATE #{table_name_child} child
          JOIN #{table_name_parent} parent ON child.#{foreign_key_id} = parent.id
          SET child.#{foreign_key_uuid} = parent.uuid;
        SQL

        # change_column_null :pistons, :engine_uuid, false
        change_column_null table_name_child, foreign_key_uuid, false

        # add_index :pistons, :engine_uuid
        add_index table_name_child, foreign_key_uuid

        # add_foreign_key :pistons, :engines, column: :engine_uuid, primary_key: :uuid, type: :binary
        add_foreign_key table_name_child, table_name_parent, column: foreign_key_uuid, primary_key: :uuid, type: :binary

        # remove_column table_name_child, foreign_key_id
        # rename_column table_name_child, foreign_key_uuid, foreign_key_id
      end
    end
  end
end
