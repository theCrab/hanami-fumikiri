describe Hanami::Fumikiri do
  let(:action) do
    Class.new do
      include Hanami::Action

      def call(params)
      end
    end.new
  end

  describe 'test private methods' do
    describe 'authenticated?' do
      it 'Guest.new => false' do
        action.instance_variable_set("@current_user", Guest.new)
        expect(action.send(:authenticated?)).to eq false
      end

      it 'nil => false' do
        action.instance_variable_set("@current_user", nil)
        expect(action.send(:authenticated?)).to eq false
      end

      it 'user => true' do
        action.instance_variable_set("@current_user", UserRepository.new.create(User.new(name: 'Bob')))
        expect(action.send(:authenticated?)).to eq true
      end
    end

  end
end
