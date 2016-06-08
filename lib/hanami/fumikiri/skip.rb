module Hanami
  module Fumikiri
    module Skip
      private

      def current_user
        Guest.new
      end
    end
  end
end
