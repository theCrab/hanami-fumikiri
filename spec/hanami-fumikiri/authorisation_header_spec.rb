describe Hanami::Fumikiri do

  let(:action) do
    Class.new do
      include Hanami::Action
      include Hanami::Fumikiri

      def call(params)
      end
    end
  end

  it 'raises MissingTokenError when Authorisation is nil' do
    expect{ action.new.call('Authorisation' => nil) }.to raise_error \
      Hanami::Fumikiri::MissingTokenError
  end

  it 'should rails invalid token error' do
    expect{ action.new.call('Authorisation' => 'not_so_valid_token') }.to raise_error \
      Hanami::Fumikiri::InvalidTokenError
  end
end
