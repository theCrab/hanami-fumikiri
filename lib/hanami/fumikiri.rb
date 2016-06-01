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
      @current_user = UserRepository.find(user_id)
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
        action: 'issue'                 # Will this conflict with Hanami::Action ?
      }
      TokenHandler.new(payload).call
    end

    def decoded_token
      TokenHandler.new({ data: user_token, action: 'verify' }).call
    end

    def token_sub
      if decoded_token.success?
        # result[0].fetch('sub') # using fetch Raises an error 'KeyError: key not found:'
        # result[0]['sub'] # Fails silently if the Hash#key is missing
        decoded_token.result[0].fetch('sub') { raise MissingSubError unless user_session }
      else
        # we have an error
        decoded_token.errors
        return nil
      end
    end

    def user_token
      auth = request.env.fetch('Authentication') { raise MissingTokenError unless user_session }
      auth.sub(/Bearer\s/, '')
    end

  end
end

::Hanami::Controller.configure do
  prepare do
    include Hanami::Fumikiri
    before :authenticate!
  end
end
