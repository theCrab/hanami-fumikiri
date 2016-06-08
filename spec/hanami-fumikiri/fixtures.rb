require 'hanami/model'

class UserRepository
  include Hanami::Repository
end

class User
  include Hanami::Entity
  attributes :name, :jti, :role

  def initialize(params={})
    params = params.to_h
    params[:jti]  ||= ([*('a'..'z'), *('A'..'Z'), *(0..9)].shuffle[0,20].join)
    params[:role] ||= 'role:admin'
    super(params)
  end
end

Hanami::Model.configure do
  adapter type: :memory, uri: 'memory://localhost/hanami-fumikiri'
  mapping do
    collection :users do
      entity     User
      repository UserRepository

      attribute :id,    Integer
      attribute :name,  String
      attribute :role,  String
      attribute :jti,   String
    end
  end
end.load!
