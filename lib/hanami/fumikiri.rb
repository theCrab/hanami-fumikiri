require 'hanami/controller'

module Hanami
  module Fumikiri

    private

    def authenticate!
      redirect_to '/login' unless authenticated?
    end

    def authenticated?
      !!@current_user && !@current_user.kind_of?(Guest)
    end

    def set_user
      @current_user = UserRepository.new.find(token_sub)
    rescue MissingTokenError
      @current_user = Guest.new
    end

    def token_sub
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
        data: {
          sub: user.id,                 # subject:
          iat: Time.now.to_i,           # issued_at: DateTime when it was created
          exp: Time.now.to_i + 800407,  # expire: DateTime when it expires
          aud: user.role,               # audience: [1000, 301, 500, ...], could be a user/app role/ACL
          iss: 'thecrab.com',           # issuer: who issued the token
          jti: user.jti                 # JWT ID: we can store this in db
        },
        action: 'issue'                 # Should not, its inside data
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
