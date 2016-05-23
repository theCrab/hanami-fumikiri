module Hanami
  module Fumikiri
    module Skip
      private
      def authenticate!
        # no-op
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

    private
    def current_user
      if !user_token.empty?
        validate_jwt
        @current_user = UserRepository.find(@decoded_token['sub'])
      elsif user_id
        @current_user = UserRepository.find(user_id)
      else
        raise MissingTokenError # or redirect_to '/some_url'
      end
    end

    def authenticate!
      redirect_to '/login' unless authenticated?
    end

    def authenticated?
      ! current_user.nil?
    end

    def user_id
      sessions['user_id']
    end

    def user_token
      request.env['Authentication']
    end

    def validate_jwt
      begin
        token = user_token.sub(/Bearer\s/, '')
        @decoded_token = JWT.decode(token, ENV['JWT_SECRET'])
        # make better errors
        # we should let this error bubble-up
        # raise InvalidTokenError if @decoded_token['sub'].empty?

      rescue JWT::DecodeError
        # make better errors
        raise InvalidTokenError
      end
    end
  end
end
