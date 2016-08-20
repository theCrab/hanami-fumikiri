require 'hanami/controller'

module Hanami
  # Fumikiri namespace
  module Fumikiri
    private

    def authenticate!
      redirect_to '/signin' unless authenticated?
    end

    def authenticated?
      !@current_user && !@current_user.is_a?(Guest)
    end

    def set_user
      return @current_user = Guest.new unless decoded_token
      @current_user = UserRepository.new.find(token_sub)
    end

    def token_sub
      decoded_token.result[0].fetch('sub')
    end

    def decoded_token
      unless user_token.nil? || user_token.size == 0
        TokenHandler.new(data: user_token, action: 'verify').call
      end
    end

    def user_token
      auth_token || authentication_header
    end

    def auth_token
      request.env.fetch('auth_token', nil)
    end

    def authentication_header
      request.env.fetch('Authentication', '').sub(/Bearer\s/, '')
    end

    def create_token(user)
      payload = {
        data: {
          sub: user.id,                 # subject:
          iat: Time.now.to_i,           # issued_at: DateTime when created
          exp: Time.now.to_i + 800_407, # expire: DateTime when it expires
          aud: user.role,               # audience: [1000, 301, 500, ...]
          iss: 'thecrab.com',           # issuer: who issued the token
          jti: user.jti                 # JWT ID: we can store this in db
        },
        action: 'issue'
      }
      TokenHandler.new(payload).call
    end
  end
end

::Hanami::Controller.configure do
  prepare do
    include Hanami::Fumikiri
    before :set_user, :authenticate!
    expose :set_user, :current_user # Exposing set_user to bubble up errors
  end
end
