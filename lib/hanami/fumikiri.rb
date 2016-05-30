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
      validate_jwt
      @current_user = UserRepository.find(user_id)
      raise MissingUserError unless @current_user # or redirect_to '/some_url'
      @current_user
    end

    def authenticate!
      redirect_to '/login' unless authenticated?
    end

    def authenticated?
      !!current_user
    end

    def user_session
      nil # temporary until real session
    end

    def user_id
      token_sub || user_session
    end

    def token_sub
      @decoded_token.fetch('sub') { raise MissingSubError unless user_session }
    end

    def user_token
      request.env.fetch('Authentication') { raise MissingTokenError unless user_session }
    end

    def validate_jwt
      begin
        token = user_token.sub(/Bearer\s/, '')
        @decoded_token = JWT.decode(token, ENV['JWT_SECRET'])
      rescue JWT::DecodeError => e
        raise e
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
