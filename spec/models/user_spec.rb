describe User, type: :model do
  describe 'methods' do
  	before do
  		@user = Fabricate(:user)
  		@admin = Fabricate(:admin_user)
  	end
  	describe '#is?' do
  		it 'return true if correct user role supplied' do
  			expect(@user.is?(:user)).to be true
  			expect(@admin.is?(:admin)).to be true
  		end

  		it 'return false if non-correct user role supplied' do
  			expect(@admin.is?(:user)).to be false
  			expect(@user.is?(:admin)).to be false
  		end
  	end
  end

  describe 'validations' do
  	it 'role inclusion in [admin, user]' do
  		expect{Fabricate(:user, role: 'dummy')}.to raise_error(ActiveRecord::RecordInvalid)
  		expect(Fabricate(:user)).to be_valid
  		expect(Fabricate(:admin_user)).to be_valid
  	end
  end
end
