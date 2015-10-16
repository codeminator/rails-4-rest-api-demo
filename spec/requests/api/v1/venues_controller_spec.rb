describe Api::V1::VenuesController, type: :request do

  before(:each) do
    @admin = Fabricate(:admin)
    @user = Fabricate(:user)
    @guest = Fabricate(:guest)
  end

  describe '#GET index' do
    #Any role can read everything
    configatron.models.user.available_roles.each do |role_name|
      context "as #{role_name}" do
        before(:each) do
          user = Fabricate(role_name)
          @venues = Fabricate.times(10, :venue, creator: user)
          get api_venues_path, {
            user_token: user.authentication_token,
            user_email: user.email
          }, request_headers
        end
        it 'fetch a list of venues from DB' do
          expect(assigns(:venues).count).to eq(@venues.count)
        end

        it 'respond with code 200' do
          expect(response.status).to eq 200
          expect(response).to render_template :index
        end
      end
    end
  end

  describe '#GET show' do
    #Any role can read everything
    configatron.models.user.available_roles.each do |role_name|
      context "as #{role_name}" do
        before(:each) do
          user = Fabricate(role_name)
          @venue = Fabricate(:venue, creator: user)
          get api_venue_path(@venue), {
            user_token: user.authentication_token,
            user_email: user.email
          }, request_headers
        end
        it 'fetch the correct venue from DB' do
          expect(assigns(:venue).id).to eq(@venue.id)
        end

        it 'respond with code 200' do
          expect(response.status).to eq 200
          expect(response).to render_template :show
        end
      end
    end
  end

  describe '#POST create' do
    #Both admin & user roles can create
    [:admin, :user].each do |role_name|
      context "as #{role_name}" do
        before(:each) do
          user = Fabricate(role_name)
          @venue_attributes = Fabricate.attributes_for(:venue, creator: user)
          post api_venues_path, {
            user_token: user.authentication_token,
            user_email: user.email,
            venue: @venue_attributes
          }, request_headers
        end
        it 'Successfully add the venue to DB' do
          expect(Venue.last.name).to eq(@venue_attributes[:name])
        end

        it 'respond with code 201' do
          expect(response.status).to eq 201
          expect(response).to render_template :show
        end
      end
    end

    context 'as guest' do
      before do
        user = Fabricate(:guest)
        @venue_attributes = Fabricate.attributes_for(:venue, creator: user)
        post api_venues_path, {
          user_token: user.authentication_token,
          user_email: user.email,
          venue: @venue_attributes
        }, request_headers
      end
      it 'prevented from creating a venue' do
        expect(Venue.last.try(:name)).to_not eq(@venue_attributes[:name])
        expect(response.status).to eq 403
      end
    end
  end

  describe '#PUT update' do
    before do
      @new_attributes = Fabricate.attributes_for(:venue)
    end
    context 'as admin' do
      it 'can update his own venues' do
        venue = Fabricate(:venue, creator: @admin)
        put api_venue_path(venue), {
          user_token: @admin.authentication_token,
          user_email: @admin.email,
          venue: @new_attributes
        }, request_headers

        venue.reload

        expect(response).to render_template :show
        expect(response.status).to eq 200
        expect(venue.name).to eq(@new_attributes[:name])
      end

      it 'can update others venues' do
        venue = Fabricate(:venue, creator: @user)
        put api_venue_path(venue), {
          user_token: @admin.authentication_token,
          user_email: @admin.email,
          venue: @new_attributes
        }, request_headers

        venue.reload

        expect(response).to render_template :show
        expect(response.status).to eq 200
        expect(venue.name).to eq(@new_attributes[:name])
      end
    end

    context 'as user' do
      it 'can update his own venues' do
        venue = Fabricate(:venue, creator: @user)
        put api_venue_path(venue), {
          user_token: @user.authentication_token,
          user_email: @user.email,
          venue: @new_attributes
        }, request_headers

        venue.reload

        expect(response).to render_template :show
        expect(response.status).to eq 200
        expect(venue.name).to eq(@new_attributes[:name])
      end

      it 'cannot update others venues' do
        venue = Fabricate(:venue, creator: Fabricate(:user))
        put api_venue_path(venue), {
          user_token: @user.authentication_token,
          user_email: @user.email,
          venue: @new_attributes
        }, request_headers
        
        venue.reload

        expect(response.status).to eq 403
        expect(venue.name).not_to eq(@new_attributes[:name])
      end
    end

    context 'as guest' do
      it 'prevented from updating a venue' do
        venue = Fabricate(:venue, creator: @user)

        put api_venue_path(venue), {
          user_token: @guest.authentication_token,
          user_email: @guest.email,
          venue: @new_attributes
        }, request_headers

        expect(response.status).to eq 403
      end
    end
  end

  describe '#DELETE destroy' do
    context 'as admin' do
      it 'can destroy his own venues' do
        venue = Fabricate(:venue, creator: @admin)

        expect { 
          delete api_venue_path(venue), {
            user_token: @admin.authentication_token,
            user_email: @admin.email,
          }, request_headers
        }.to change(Venue, :count).by(-1)

        expect(response.status).to eq 204
      end

      it 'can destroy others venues' do
        venue = Fabricate(:venue, creator: @user)

        expect { 
          delete api_venue_path(venue), {
            user_token: @admin.authentication_token,
            user_email: @admin.email,
          }, request_headers
        }.to change(Venue, :count).by(-1)

        expect(response.status).to eq 204
      end
    end

    context 'as user' do
      it 'can destroy his own venues' do
        venue = Fabricate(:venue, creator: @user)

        expect { 
          delete api_venue_path(venue), {
            user_token: @user.authentication_token,
            user_email: @user.email,
          }, request_headers
        }.to change(Venue, :count).by(-1)

        expect(response.status).to eq 204
      end

      it 'cannot destroy others venues' do
        venue = Fabricate(:venue, creator: Fabricate(:user))

        expect { 
          delete api_venue_path(venue), {
            user_token: @user.authentication_token,
            user_email: @user.email,
          }, request_headers
        }.not_to change(Venue, :count)

        expect(response.status).to eq 403
      end
    end

    context 'as guest' do
      it 'prevented from deleting a venue' do
        venue = Fabricate(:venue, creator: @user)

        expect { 
          delete api_venue_path(venue), {
            user_token: @guest.authentication_token,
            user_email: @guest.email,
          }, request_headers
        }.not_to change(Venue, :count)

        expect(response.status).to eq 403
      end
    end
  end
end
