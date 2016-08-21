# hanami-fumikiri

[![Coverage Status](https://coveralls.io/repos/github/theCrab/hanami-fumikiri/badge.svg?branch=master)](https://coveralls.io/github/theCrab/hanami-fumikiri?branch=master) [![Join the chat at https://gitter.im/theCrab/hanami-fumikiri](https://badges.gitter.im/theCrab/hanami-fumikiri.svg)](https://gitter.im/theCrab/hanami-fumikiri?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
Hanami User Authentication.  

**[PLEASE CHECK THIS GIST FIRST](https://gist.github.com/theCrab/54a339b7a08ddad84e35)**

As most will know by now, Hanami Framework is turning out to be a very well thought one.
I have found that it is best suited for API apps and as it goes, there is no single best practice or gem that the Hanami community is pouring into for the all important Authentication side of things. This gem is a trial at answering this question.

This is to help newcomers get up and running as quick and from experience it has been this part that is holding back a lot of developers. The need to get a quick concept/project out there or to have a backend for a mobile app is growing. Speed to launch counts and a community effort on authentication and authorization should kinda come along with the framework.

Fumikiri means a gate across a railway crossing.

## Concepts
This approach is inclined towards separating the Hanami Stack from the front-end. While Hanami has a very good asset and front-end support. We recommend separating the two completely. Therefore, Fumikiri is totally implemented for JSON Web Tokens.

## User Authentication
Light and completely follows the JWT official Specifications.
Support for
- [x] <del>Allow username and password-based authentication</del>. This is the responsibility of a `Signup/User management` process, which every app must implement based on its needs. However, we expect to receive a JWT token in a in the form of a cookie `'auth_token'` or header `'Authentication'= 'Bearer '`.
- [x] username and password based accounts <del>are always enabled</del>. We have provided an [example app](https://github.com/theCrab/Bookshelf) to illustrate this. Your app should implement its own requirements.

## User Sessions
- Require revocable sessions
- Expire inactive sessions
- Revoke session on password change

## Support for reserved claim names

JSON Web Token defines some reserved claim names and defines how they should be used. JWT supports these reserved claim names:

- 'exp' (Expiration Time) Claim. Error (`JWT::ExpiredSignature`)
- 'nbf' (Not Before Time) Claim. Error (`JWT::ImmatureSignature`)
- 'iss' (Issuer) Claim. Error (`JWT::InvalidIssuerError`)
- 'aud' (Audience) Claim. Error (`JWT::InvalidAudError`)
- 'jti' (JWT ID) Claim. Error (`JWT::InvalidJtiError`)
- 'iat' (Issued At) Claim. Error (`JWT::InvalidIatError`)
- 'sub' (Subject) Claim. Error (`JWT::InvalidSubError`)


## USAGE
In your app implement the `Sessions Controller`

**NOTE: Consider using `::Users::Signup, ::Users::RevokeAccess and ::Users::ResetPassword, ::Sessions::Signin, ::Sessions::Signout`**

```rb
# apps/web/config/routes.rb
get  '/signin',  to: 'sessions#new'
post '/signin',  to: 'sessions#signin'
post '/signout', to: 'sessions#signout'

# apps/web/controllers/sessions/signin.rb
require 'bcrypt'

module Web::Controllers::Sessions
  class Signin # Login action
    include Web::Action
    include Authentication::Skip

    params do
      param :signin do
        param :username, presence: true
        param :password, presence: true
      end
    end

    def call(params)
      if params.valid?
        authenticate_user
        # if using headers
        self.headers.merge!({ 'Authentication' => "Bearer #{@token.result}" })
        # if using sessions/cookies
        self.session[:auth_token] = @token.result

        redirect_to "/users/#{user.id}"
      end
    end

    # You could move a lot of this code to an Interactor for reuse in API, CLI etc
    private
    def login_username
      params.get('signin.username').strip.downcase.gsub(/\s+/, '')
    end

    def login_password
      params.get('signin.password')
    end

    def user
      UserRepository.find_by_email(login_username)
    end

    def valid_password?
      BCrypt::Password.new(user.password_hash) == login_password
    end

    def authenticate_user
      if !user.nil? && valid_password?
      # payload = { data: { sub: 'user.id'}, action: 'issue'}
        payload = { data: { sub: user.id, iat: Time.now.to_i, exp: Time.now.to_i + 800407, aud: 'role:admin' }, action: 'issue' }
        @token = Fumikiri.new(payload).call
      end
    end
  end
end
```
