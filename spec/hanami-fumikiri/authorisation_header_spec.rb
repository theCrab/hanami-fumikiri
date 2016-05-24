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

  describe 'actions calls that contain faulty data' do

    it 'raises MissingTokenError when Authentication is missing' do
      expect{ action.new.call({}) }.to raise_error \
        Hanami::Fumikiri::MissingTokenError
    end

    it 'raises error when invalid token' do
      expect{ action.new.call('Authentication' => 'not_so_valid_token') }.to raise_error \
        Hanami::Fumikiri::InvalidTokenError
    end
  end

  it 'raises no errors' do
    expect{ action.new.call('Authentication' => "Bearer #{encoded_data}") }.not_to raise_error
  end

  describe 'action values' do

    before do
      @a = action.new
      @a.call('Authentication' => "Bearer #{encoded_data}")
    end

    it 'returs a user with same id as sub' do
      expect(@a.user.id).to eq 1
    end

  end
end
