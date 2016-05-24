describe Hanami::Fumikiri do

  let(:action) do
    Class.new do
      include Hanami::Action
      include Hanami::Fumikiri::Skip

      def call(params)
      end
    end
  end

  it 'passes when skip is included' do
    expect{ action.new.call({}) }.not_to raise_error
  end

end
