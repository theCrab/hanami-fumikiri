require 'hanami/controller'

module Hanami
  module Fumikiri

    def self.included(base)
      base.class_eval do
        expose :current_user
      end
    end

    private

    def authenticate!
      redirect_to '/login' unless authenticated?
    end

    def authenticated?
      !!current_user
    end

    def current_user
      @current_user = UserRepository.find(token_sub)
    end

    def token_sub
      ## Moved hadling of failure to TokenHandler
      # this way here we can write only code for successfull requests
      # what you think of this, makes any sense?
      decoded_token.result[0].fetch('sub')
    end

    def decoded_token
      TokenHandler.new({ data: user_token, action: 'verify' }).call
    end

    def user_token
      auth_token || authentication_header
    end

    def auth_token
      request.env['auth_token']
    end

    def authentication_header
      (request.env.fetch('Authentication') { raise MissingTokenError }).
        sub(/Bearer\s/, '')
    end

    def create_token(user)
      payload = {
        data: { sub: user.id, iat: Time.now.to_i, exp: Time.now.to_i + 800407, aud: 'role:admin' },
        action: 'issue'
      }
      TokenHandler.new(payload).call.result
    end
  end
end

::Hanami::Controller.configure do
  prepare do
    include Hanami::Fumikiri
    before :authenticate!
  end
end
