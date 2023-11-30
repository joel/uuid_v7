# frozen_string_literal: true

require "mysql-binuuid/type"

module UuidV7
  module Base
    extend ActiveSupport::Concern

    included do
      attribute :uuid, MySQLBinUUID::Type.new

      after_initialize :assign_uuid, if: :new_record?
    end

    class_methods do
      def find_by_base58_uuid(base58_uuid)
        find_by(uuid: Converter.base58_to_uuid(base58_uuid))
      end
    end

    def uuid_as_base58
      Converter.uuid_to_base58(uuid)
    end

    def uuid_as_int
      Converter.uuid_to_int(uuid)
    end

    protected

    def assign_uuid
      return unless respond_to?(:uuid=)

      self.uuid ||= SecureRandom.uuid_v7
    end
  end
end
