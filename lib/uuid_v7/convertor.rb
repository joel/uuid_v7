# frozen_string_literal: true

require "base58"

module UuidV7
  class Convertor
    class << self
      def uuid_to_int(uuid)
        raise ArgumentError, "Invalid UUID" unless uuid.match?(/\A\h{8}-\h{4}-\h{4}-\h{4}-\h{12}\z/)

        uuid.delete("-").to_i(16)
      end

      def uuid_to_base58(uuid)
        Base58.int_to_base58(uuid_to_int(uuid))
      end

      def base58_to_int(base58)
        raise ArgumentError, "Invalid Base58" unless base58.match?(/\A\w{21}\z/)

        Base58.base58_to_int(base58)
      end

      def int_to_uuid(int)
        raise ArgumentError, "Invalid Integer" unless int.is_a?(Integer)

        b16 = int.to_s(16).rjust(32, "0")

        "#{b16[0...8]}-#{b16[8...12]}-#{b16[12...16]}-#{b16[16...20]}-#{b16[20...32]}"
      end
    end
  end
end
