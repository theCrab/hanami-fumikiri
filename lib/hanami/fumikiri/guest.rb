require 'hanami/model'

class Guest
  include Hanami::Entity
  attributes :name, :jti, :role

  def initialize(params={})
    params = params.to_h
    params[:jti]  ||= ([*('a'..'z'), *('A'..'Z'), *(0..9)].shuffle[0,20].join)
    params[:role] ||= 'role:guest'
    params[:name] ||= 'Guest'
    super(params)
  end
end
