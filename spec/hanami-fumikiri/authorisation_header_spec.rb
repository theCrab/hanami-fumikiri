describe Hanami::Fumikiri do

  let(:action) do
    Class.new do
      include Hanami::Action

      def call(params)
      end
    end
  end

  let(:secret)       { 'jwt$3cr3t' }
  let(:user)         { UserRepository.new.create(User.new(name: 'Bob'))  }
  let(:encoded_data) { action.new.send(:create_token, user) }

  before { ENV['JWT_SECRET'] = secret }
  after  { UserRepository.new.clear   }

  describe 'guest action calls' do
    it 'current_user should be Guest' do
      request = action.new
      request.call({})
      expect(request.user).to be_kind_of Guest
    end

    it 'returns the right status' do
      expect(action.new.call({})[0]).to eq 302
    end
  end

  describe 'invalid action calls' do


    it 'raises error when invalid token' do
      expect{ action.new.call('Authentication' => 'not_so_valid_token') }.to raise_error \
        JWT::DecodeError
    end

    describe "missing payload data keys" do
      before do
        @valid_data = {
          sub: user.id,                 # subject:
          iat: Time.now.to_i,           # issued_at: DateTime when it was created
          exp: Time.now.to_i + 800407,  # expire: DateTime when it expires
          aud: user.role,               # audience: [1000, 301, 500, ...], could be a user/app role/ACL
          iss: 'thecrab.com',           # issuer: who issued the token
          jti: user.jti                 # JWT ID: we can store this in db
        }
      end

      it 'no sub' do
        invalid_data = @valid_data.reject { |key| key == :sub }
        invalid_token = JWT.encode(invalid_data, ENV['JWT_SECRET'], 'HS256')
        expect{ action.new.call('Authentication' => "Bearer #{invalid_token}") }.to raise_error \
          KeyError
      end

      it 'no iss' do
        invalid_data = @valid_data.reject { |key| key == :iss }
        invalid_token = JWT.encode(invalid_data, ENV['JWT_SECRET'], 'HS256')
        expect{ action.new.call('Authentication' => "Bearer #{invalid_token}") }.to raise_error \
          JWT::InvalidIssuerError
      end

      it 'no aud' do
        invalid_data = @valid_data.reject { |key| key == :aud }
        invalid_token = JWT.encode(invalid_data, ENV['JWT_SECRET'], 'HS256')
        expect{ action.new.call('Authentication' => "Bearer #{invalid_token}") }.to raise_error \
          JWT::InvalidAudError
      end

      it 'no jti' do
        invalid_data = @valid_data.reject { |key| key == :jti }
        invalid_token = JWT.encode(invalid_data, ENV['JWT_SECRET'], 'HS256')
        expect{ action.new.call('Authentication' => "Bearer #{invalid_token}") }.to raise_error \
         JWT::InvalidJtiError 
      end

      # it 'no iat' do
      #   invalid_data = @valid_data.reject { |key| key == :iat }
      #   invalid_token = JWT.encode(invalid_data, ENV['JWT_SECRET'], 'HS256')
      #   expect{ action.new.call('Authentication' => "Bearer #{invalid_token}") }.to raise_error \
      #    JWT::InvalidJtiError 
      # end

      # it 'no exp' do
      #   invalid_data = @valid_data.reject { |key| key == :exp }
      #   invalid_token = JWT.encode(invalid_data, ENV['JWT_SECRET'], 'HS256')
      #   expect{ action.new.call('Authentication' => "Bearer #{invalid_token}") }.to raise_error \
      #    JWT::InvalidJtiError 
      # end
    end
  end

  describe 'valid action calls' do

    it 'raises no errors' do
      expect(encoded_data.success?).to be(true)
      expect{ action.new.call('Authentication' => "Bearer #{encoded_data.result}") }.not_to raise_error
      expect(action.new.call('Authentication' => "Bearer #{encoded_data.result}")[0]).to eq 200
    end

    it 'returs a user with same id as sub' do
      request = action.new
      request.call('Authentication' => "Bearer #{encoded_data.result}")
      expect(request.user).to eq UserRepository.new.find(1)
    end

  end
end
