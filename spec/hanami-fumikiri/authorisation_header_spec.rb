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
  let(:data)         { { sub: 1, name: 'Doe' } }
  let(:encoded_data) { JWT.encode data, secret, 'HS256' }


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
