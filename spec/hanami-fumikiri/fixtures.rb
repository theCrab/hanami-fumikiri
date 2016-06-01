class UserRepository
  attr_accessor :id, :role, :jti

  def initialize(id)
    @id   = id
    @role = 'role:admin'
    @jti  = "d2e9c5ea-30af-4c81-b4c4-7c864311db67" # SecureRandom.uuid
  end

  def self.find(id)
    new(id)
  end
end
