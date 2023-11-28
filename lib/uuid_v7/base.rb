# frozen_string_literal: true

module UuidV7
  module Base
    extend ActiveSupport::Concern

    included do
      after_initialize :set_uniq_identifier
    end

    def uuid_to_int
      Convertor.uuid_to_int(uuid)
    end

    protected

    def set_uniq_identifier
      return unless respond_to?(:uuid)

      self.uuid ||= SecureRandom.uuid_v7
    end
  end
end
