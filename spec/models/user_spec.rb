require 'cancan/matchers'

describe User, type: :model do
  before do
    @guest = Fabricate(:guest)
    @user = Fabricate(:normal_user)
    @admin = Fabricate(:admin_user)
  end

  describe 'abilities' do
    subject(:ability){ Ability.new(user) }

    context 'when is a guest' do
      let(:user) { @guest }
      it { should be_able_to(:read, :all) }
      it { should_not be_able_to(:create, Activity.new) }
      it { should_not be_able_to(:create, Venue.new) }
      [:update, :destroy].each do |action|
        it { should_not be_able_to(action, Activity.new(user: @user)) }
        it { should_not be_able_to(action, Venue.new(creator: @user)) }
      end
    end

    context 'when is a normal user' do
      let(:user) { @user }
      it { should be_able_to(:read, :all) }
      it { should be_able_to(:create, :all) }
      #activity
      it { should be_able_to(:update, Activity.new(user: user)) }
      it { should be_able_to(:destroy, Activity.new(user: user)) }
      it { should_not be_able_to(:update, Activity.new(user: Fabricate(:normal_user))) }
      it { should_not be_able_to(:destroy, Activity.new(user: Fabricate(:normal_user))) }
      #venue
      it { should be_able_to(:update, Venue.new(creator: user)) }
      it { should be_able_to(:destroy, Venue.new(creator: user)) }
      it { should_not be_able_to(:update, Venue.new(creator: Fabricate(:normal_user))) }
      it { should_not be_able_to(:destroy, Venue.new(creator: Fabricate(:normal_user))) }
    end

    context 'when is an admin' do
      let(:user) { @admin }
      it { should be_able_to(:manage, :all) }
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
