# frozen_string_literal: true

module UuidV7
  module Patches
    module Mysql
      module FxMigration
        def populate_uuid_field(table_name:, column_name:)
          table_name  = table_name.to_s.to_sym
          column_name = column_name.to_s.to_sym

          raise ArgumentError, "Column #{column_name} does not exist on table #{table_name}" unless column_exists?(table_name, column_name)

          connection.execute <<~SQL
            DROP FUNCTION IF EXISTS uuid_v7;
          SQL

          connection.exec_query <<~SQL.squish
            CREATE FUNCTION uuid_v7 (time_of_creation DATETIME)
            RETURNS BINARY(16)
            LANGUAGE SQL
            NOT DETERMINISTIC
            NO SQL
            SQL SECURITY DEFINER
            BEGIN
              DECLARE uuid          CHAR(36);
              DECLARE undashed_uuid CHAR(32);
              DECLARE currentTime   BIGINT;
              DECLARE buuid         BINARY(16);

              SET currentTime = UNIX_TIMESTAMP(time_of_creation) * 1000 + FLOOR(MICROSECOND(NOW(6)) / 1000);

              SET uuid = LOWER(
                CONCAT(
                  LPAD(HEX(currentTime), 12, '0'), '-7',
                  LPAD(HEX(FLOOR(RAND() * 0x1000)), 3, '0'), '-',
                  HEX(0x8000 | FLOOR(RAND() * 0x4000)), '-',
                  LPAD(HEX(FLOOR(RAND() * 0x1000000000000)), 12, '0')
                )
              );

              SET undashed_uuid = REPLACE(uuid, '-', '');
              SET buuid = UNHEX(undashed_uuid);

              RETURN buuid;
            END
          SQL

          connection.execute <<~SQL
            UPDATE #{table_name} SET #{column_name} = uuid_v7(created_at) WHERE #{column_name} IS NULL;
          SQL

          connection.execute <<~SQL
            DROP FUNCTION IF EXISTS uuid_v7;
          SQL
        end
      end
    end
  end
end
