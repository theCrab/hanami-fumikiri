module Hanami
  module Fumikiri
    module Skip
      private
      def authenticate!
        # no-op implementation
      end
    end

    class InvalidTokenError < StandardError
      def message
        "Your token has problems... "
      end
    end

    class MissingTokenError < StandardError
      def message
        "No 'Authorisation' header provided."
      end
    end

    def self.included(base)
      base.class_eval do
        before :authenticate!
        expose :current_user
      end
    end

    def current_user
      validate_jwt
      @current_user = UserRepository.find(@decoded_token['user_id'])
    end

    private
    def authenticate!
      redirect_to '/login' unless authenticated?
    end

    def authenticated?
      ! current_user.nil?
    end

    def validate_jwt
      begin
        auth = request.env['Authorisation']
        raise MissingTokenError if auth.nil?

        token = auth.split(' ').last
        @decoded_token = JWT.decode(token, ENV['JWT_SECRET'])
        # make better errors
        raise InvalidTokenError if @decoded_token['user_id'].empty?

      rescue JWT::DecodeError
        # make better errors
        raise InvalidTokenError
      end
    end
  end
end
