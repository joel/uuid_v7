# frozen_string_literal: true

module UuidV7
  module Base
    extend ActiveSupport::Concern

    included do
      attribute UuidV7.configuration.field_name, :uuid_v7, default: -> { SecureRandom.uuid_v7 }
    end
  end
end
