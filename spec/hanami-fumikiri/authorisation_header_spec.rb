describe Hanami::Fumikiri do

  let(:action) do
    Class.new do
      include Hanami::Action
      include Hanami::Fumikiri

      def call(params)
      end
    end
  end

  it 'raises MissingTokenError when Authorisation is missing' do
    expect{ action.new.call({}) }.to raise_error \
      Hanami::Fumikiri::MissingTokenError
  end

  it 'raises error when invalid token' do
    expect{ action.new.call('Authorisation' => 'not_so_valid_token') }.to raise_error \
      Hanami::Fumikiri::InvalidTokenError
  end
end
