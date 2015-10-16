require 'cancan/matchers'

describe User, type: :model do
  before do
    @guest = Fabricate(:guest)
    @user = Fabricate(:user)
    @admin = Fabricate(:admin)
  end

  describe 'abilities' do
    subject(:ability){ Ability.new(user) }

    context 'when is a guest' do
      let(:user) { @guest }
      it { is_expected.to be_able_to(:read, :all) }
      it { is_expected.to_not be_able_to(:create, Activity.new) }
      it { is_expected.to_not be_able_to(:create, Venue.new) }
      [:update, :destroy].each do |action|
        it { is_expected.to_not be_able_to(action, Activity.new(user: @user)) }
        it { is_expected.to_not be_able_to(action, Venue.new(creator: @user)) }
      end
    end

    context 'when is a normal user' do
      let(:user) { @user }
      it { is_expected.to be_able_to(:read, :all) }
      it { is_expected.to be_able_to(:create, :all) }
      #activity
      it { is_expected.to be_able_to(:update, Activity.new(user: user)) }
      it { is_expected.to be_able_to(:destroy, Activity.new(user: user)) }
      it { is_expected.to_not be_able_to(:update, Activity.new(user: Fabricate(:user))) }
      it { is_expected.to_not be_able_to(:destroy, Activity.new(user: Fabricate(:user))) }
      #venue
      it { is_expected.to be_able_to(:update, Venue.new(creator: user)) }
      it { is_expected.to be_able_to(:destroy, Venue.new(creator: user)) }
      it { is_expected.to_not be_able_to(:update, Venue.new(creator: Fabricate(:user))) }
      it { is_expected.to_not be_able_to(:destroy, Venue.new(creator: Fabricate(:user))) }
    end

    context 'when is an admin' do
      let(:user) { @admin }
      it { is_expected.to be_able_to(:manage, :all) }
    end

  end

  describe 'methods' do
    describe '#is?' do
      it 'return true if correct user role supplied' do
        expect(@guest.is?(:guest)).to be true
        expect(@user.is?(:user)).to be true
        expect(@admin.is?(:admin)).to be true
      end

      it 'return false if non-correct user role supplied' do
        expect(@guest.is?(:user)).to be false
        expect(@admin.is?(:user)).to be false
        expect(@user.is?(:admin)).to be false
      end
    end
  end

  describe 'validations' do
    it "role inclusion in (#{configatron.models.user.available_roles.join(', ')})" do
      expect{Fabricate(:user, role: 'dummy')}.to raise_error(ActiveRecord::RecordInvalid)
      expect(@guest).to be_valid
      expect(@user).to be_valid
      expect(@admin).to be_valid
    end
  end
end
