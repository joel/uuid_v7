# frozen_string_literal: true

module UuidV7
  class Configuration
    attr_accessor :field_name, :implicit_inclusion_strategy

    def initialize
      self.field_name = :id
      self.implicit_inclusion_strategy = true
    end
  end
end
