describe Hanami::Fumikiri do
  let(:action) do
    Class.new do
      include Hanami::Action
      expose :user

      def call(params)
        @user = current_user
      end
    end.new
  end

  describe 'test private methods' do
    describe 'authenticated?' do
      it 'Guest.new => false' do
        action.define_singleton_method(:current_user) { Guest.new }
        expect(action.send(:authenticated?)).to eq false
      end

      it 'nil => false' do
        action.define_singleton_method(:current_user) { nil }
        expect(action.send(:authenticated?)).to eq false
      end

      it 'user => true' do
        action.define_singleton_method(:current_user) { UserRepository.new.create(User.new(name: 'Bob')) }
        expect(action.send(:authenticated?)).to eq true
      end
    end

  end
end
