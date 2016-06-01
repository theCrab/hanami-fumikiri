describe Hanami::Fumikiri do

  let(:action) do
    Class.new do
      include Hanami::Action
      expose :user

      def call(params)
        @user = current_user
      end
    end
  end

  let(:secret)       { 'jwt$3cr3t' }
  let(:user)         { UserRepository.new(1) }
  let(:encoded_data) { action.new.send(:create_token, user) }

  before { ENV['JWT_SECRET'] = secret }

  describe 'invalid action calls' do

    it 'raises MissingTokenError when Authentication is missing' do
      expect{ action.new.call({}) }.to raise_error \
        Hanami::Fumikiri::MissingTokenError
    end

    it 'raises error when invalid token' do
      expect{ action.new.call('Authentication' => 'not_so_valid_token') }.to raise_error \
        JWT::DecodeError
    end

    it 'raises error sub missing' do
      no_sub_data = { no_sub: user.id, iat: Time.now.to_i, exp: Time.now.to_i + 800407, aud: 'role:admin' }
      invalid_token = JWT.encode(no_sub_data, ENV['JWT_SECRET'], 'HS256')
      expect{ action.new.call('Authentication' => "Bearer #{invalid_token}") }.to raise_error \
        Hanami::Fumikiri::MissingSubError
    end
  end

  describe 'valid action calls' do

    it 'raises no errors' do
      expect{ action.new.call('Authentication' => "Bearer #{encoded_data}") }.not_to raise_error
    end

    it 'returs a user with same id as sub' do
      valid_request = action.new
      valid_request.call('Authentication' => "Bearer #{encoded_data}")
      expect(valid_request.user.id).to eq 1
    end

  end
end
