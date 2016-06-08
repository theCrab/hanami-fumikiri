module Hanami
  module Fumikiri
    module Skip
      private

      def set_user
        Guest.new
      end
    end
  end
end
