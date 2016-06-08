describe Hanami::Fumikiri do

  let(:action) do
    Class.new do
      include Hanami::Action
      include Hanami::Fumikiri::Skip

      def call(params)
      end
    end
  end

  let(:user) { User.new(id: 1) }
  let(:encoded_data) { action.new.send(:create_token, user) }

  describe 'passes with faulty token' do

    it 'raises error when invalid token' do
      expect{ action.new.call('Authentication' => 'not_so_valid_token') }.not_to raise_error
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
        expect{ action.new.call('Authentication' => "Bearer #{invalid_token}") }.not_to raise_error
      end

      it 'no iss' do
        invalid_data = @valid_data.reject { |key| key == :iss }
        invalid_token = JWT.encode(invalid_data, ENV['JWT_SECRET'], 'HS256')
        expect{ action.new.call('Authentication' => "Bearer #{invalid_token}") }.not_to raise_error
      end

      it 'no aud' do
        invalid_data = @valid_data.reject { |key| key == :aud }
        invalid_token = JWT.encode(invalid_data, ENV['JWT_SECRET'], 'HS256')
        expect{ action.new.call('Authentication' => "Bearer #{invalid_token}") }.not_to raise_error
      end

      it 'no jti' do
        invalid_data = @valid_data.reject { |key| key == :jti }
        invalid_token = JWT.encode(invalid_data, ENV['JWT_SECRET'], 'HS256')
        expect{ action.new.call('Authentication' => "Bearer #{invalid_token}") }.not_to raise_error
      end
    end
  end

  it 'valid action call' do
    expect(encoded_data.success?).to be(true)
    expect{ action.new.call('Authentication' => "Bearer #{encoded_data.result}") }.not_to raise_error
    expect(action.new.call('Authentication' => "Bearer #{encoded_data.result}")[0]).to eq 200
  end

  it 'empty action does not redirect' do
    expect{ action.new.call({}) }.not_to raise_error
    expect(action.new.call({})[0]).to eq 200
  end

end
