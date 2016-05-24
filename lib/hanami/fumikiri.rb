require 'pry'
require 'hanami/controller'

module Hanami
  module Fumikiri

    def self.included(base)
      base.class_eval do
        expose :current_user
      end
    end

    private
    def current_user
      if !user_token.empty?
        validate_jwt
        @current_user = UserRepository.find(@decoded_token[0]['sub'])
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
      request.env.fetch('Authentication') { raise MissingTokenError }
    end

    def validate_jwt
      begin
        token = user_token.sub(/Bearer\s/, '')
        @decoded_token = JWT.decode(token, ENV['JWT_SECRET'], 'HS256')
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

::Hanami::Controller.configure do
  prepare do
    include Hanami::Fumikiri
    before :authenticate!
  end
end
