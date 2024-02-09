# frozen_string_literal: true

module UuidV7
  class Configuration
    attr_accessor :field_name, :implicit_inclusion_strategy, :throw_invalid_uuid

    def initialize
      self.field_name = :id
      self.implicit_inclusion_strategy = true
      self.throw_invalid_uuid = true
    end
  end
end
