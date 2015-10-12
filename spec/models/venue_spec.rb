describe Venue, type: :model do
  describe 'validations' do
    context 'attributes' do
      #name
      it "name presence" do
        expect{Fabricate(:venue, name: nil)}.to raise_error(ActiveRecord::RecordInvalid)
      end
      it "name uniqueness" do
        venue = Fabricate(:venue)
        expect{Fabricate(:venue, name: venue.name)}.to raise_error(ActiveRecord::RecordInvalid)
      end
      
      #latitude
      it 'latitude must be in the proper range (between -90 & 90)' do
        expect{ Fabricate(:venue, latitude: -100) }.to raise_error(ActiveRecord::RecordInvalid)
        expect{ Fabricate(:venue, latitude: 100) }.to raise_error(ActiveRecord::RecordInvalid)
      end
      #longitude
      it 'longitude must be in the proper range (between -180 & 180)' do
        expect{ Fabricate(:venue, longitude: -200) }.to raise_error(ActiveRecord::RecordInvalid)
        expect{ Fabricate(:venue, longitude: 200) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'associations' do
      it 'creator presence' do
        expect{ Fabricate(:venue, creator: nil) }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
