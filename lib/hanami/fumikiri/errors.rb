module Hanami
  module Fumikiri

    class MissingTokenError < StandardError
      def message
        "No 'Authentication' header provided."
      end
    end

  end
end
