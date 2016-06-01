class UserRepository
  attr_accessor :id

  def initialize(id)
    @id = id
  end

  def self.find(id)
    new(id)
  end
end
