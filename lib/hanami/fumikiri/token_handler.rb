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
      end

      private
      def verify
        JWT.decode(@payload[:data], ENV['JWT_SECRET'], true, {
          # This is a block
            verify_iat: true,
            iat: true,
            verify_aud: true,
            aud: 'role:admin'
          })
      end

      def issue
        JWT.encode(@payload[:data], ENV['JWT_SECRET'], 'HS256')
      end
    end
  end
end
