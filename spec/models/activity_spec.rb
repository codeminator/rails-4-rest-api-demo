describe Activity, type: :model do 
  describe 'validations' do
    context 'attributes' do
      #name
      it "name inclusion in (#{configatron.models.activity.available_names})" do
        expect{Fabricate(:activity, name: 'dummy')}.to raise_error(ActiveRecord::RecordInvalid)
      end
      #measure_unit
      it "measure_unit inclusion in (#{configatron.models.activity.measure_units})" do
        expect{ Fabricate(:activity, measure_unit: 'dummy') }.to raise_error(ActiveRecord::RecordInvalid)
      end
      #distance
      it 'distance must be greater than zero' do
        expect{ Fabricate(:activity, distance: -100) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'associations' do
      it 'user presence' do
        expect{ Fabricate(:activity, user: nil) }.to raise_error(ActiveRecord::RecordInvalid)
      end
      it 'venue presence' do
        expect{ Fabricate(:activity, venue: nil) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
