module Hanami
  module Fumikiri

    class InvalidTokenError < StandardError
      def message
        "Your token has problems... "
      end
    end

    class MissingTokenError < StandardError
      def message
        "No 'Authentication' header provided."
      end
    end

  end
end
