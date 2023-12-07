# frozen_string_literal: true

require "uuid_v7"

class Keyboard < ActiveRecord::Base
  include UuidV7::Base
  has_many :keys
end

class Key < ActiveRecord::Base
  include UuidV7::Base
  attribute :keyboard_id, ::UuidV7::Types::Base.new
  belongs_to :keyboard
end

class Apple < ActiveRecord::Base
  include UuidV7::Base
  attribute :uuid_ref, ::UuidV7::Types::Base.new
end
