require 'hanami/interactor'

module Hanami
  module Fumikiri
    class TokenHandler
      include Hanami::Interactor
      expose :result

      def initialize(payload = {})
        @payload = payload
      end

      def call
        @result = case @payload[:action]
        when 'verify'
          verify
        when 'issue'
          issue
        end
      rescue => e
        ## Maybe instead of handling failure in the fumikiri module
        # we can handle it here instead?
        raise e
      end

      private

      def verify
        JWT.decode(@payload[:data], ENV['JWT_SECRET'], true, {
          # This is a block
            verify_iat: true,
            iat: true,
            verify_aud: true,
            aud: 'role:admin',
            # verify_jti: true,
            # jti: 'd2e9c5ea-30af-4c81-b4c4-7c864311db67',
            # verify_iss: true,
            # iss: 'thecrab.com'
          })
      end

      def issue
        JWT.encode(@payload[:data], ENV['JWT_SECRET'], 'HS256')
      end
    end
  end
end
