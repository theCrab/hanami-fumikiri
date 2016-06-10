module Hanami
  module Fumikiri
    module Skip
      private

      def authenticate!
        # no-op
      end

      def set_user
        Guest.new
      end
    end
  end
end
