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

    class MissingSubError < StandardError
      def message
        "Token has no 'sub' attribute."
      end
    end

    class MissingUserError < StandardError
      def message
        "Could not find user."
      end
    end


  end
end
