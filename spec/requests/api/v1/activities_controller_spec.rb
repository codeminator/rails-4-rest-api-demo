describe Api::V1::ActivitiesController, type: :request do

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
          @activities = Fabricate.times(10, :activity, user: user)
          get api_activities_path, {
            user_token: user.authentication_token,
            user_email: user.email
          }, request_headers
        end
        it 'fetch a list of activities from DB' do
          expect(assigns(:activities).count).to eq(@activities.count)
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
          @activity = Fabricate(:activity, user: user)
          get api_activity_path(@activity), {
            user_token: user.authentication_token,
            user_email: user.email
          }, request_headers
        end
        it 'fetch the correct activity from DB' do
          expect(assigns(:activity).id).to eq(@activity.id)
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
          @activity_attributes = Fabricate.attributes_for(:activity, user: user)
          post api_activities_path, {
            user_token: user.authentication_token,
            user_email: user.email,
            activity: @activity_attributes
          }, request_headers
        end
        it 'Successfully add the activity to DB' do
          expect(Activity.last.distance).to eq(@activity_attributes[:distance])
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
        @activity_attributes = Fabricate.attributes_for(:activity, user: user)
        post api_activities_path, {
          user_token: user.authentication_token,
          user_email: user.email,
          activity: @activity_attributes
        }, request_headers
      end
      it 'prevented from creating a activity' do
        expect(Activity.last.try(:name)).to_not eq(@activity_attributes[:name])
        expect(response.status).to eq 403
      end
    end
  end

  describe '#PUT update' do
    before do
      @new_attributes = Fabricate.attributes_for(:activity)
    end
    context 'as admin' do
      it 'can update his own activities' do
        activity = Fabricate(:activity, user: @admin)
        put api_activity_path(activity), {
          user_token: @admin.authentication_token,
          user_email: @admin.email,
          activity: @new_attributes
        }, request_headers

        activity.reload

        expect(response).to render_template :show
        expect(response.status).to eq 200
        expect(activity.distance).to eq(@new_attributes[:distance])
      end

      it 'can update others activities' do
        activity = Fabricate(:activity, user: @user)
        put api_activity_path(activity), {
          user_token: @admin.authentication_token,
          user_email: @admin.email,
          activity: @new_attributes
        }, request_headers

        activity.reload

        expect(response).to render_template :show
        expect(response.status).to eq 200
        expect(activity.distance).to eq(@new_attributes[:distance])
      end
    end

    context 'as user' do
      it 'can update his own activities' do
        activity = Fabricate(:activity, user: @user)
        put api_activity_path(activity), {
          user_token: @user.authentication_token,
          user_email: @user.email,
          activity: @new_attributes
        }, request_headers

        activity.reload

        expect(response).to render_template :show
        expect(response.status).to eq 200
        expect(activity.distance).to eq(@new_attributes[:distance])
      end

      it 'cannot update others activities' do
        activity = Fabricate(:activity, user: Fabricate(:user))
        put api_activity_path(activity), {
          user_token: @user.authentication_token,
          user_email: @user.email,
          activity: @new_attributes
        }, request_headers
        
        activity.reload

        expect(response.status).to eq 403
        expect(activity.distance).not_to eq(@new_attributes[:distance])
      end
    end

    context 'as guest' do
      it 'prevented from updating a activity' do
        activity = Fabricate(:activity, user: @user)

        put api_activity_path(activity), {
          user_token: @guest.authentication_token,
          user_email: @guest.email,
          activity: @new_attributes
        }, request_headers

        expect(response.status).to eq 403
      end
    end
  end

  describe '#DELETE destroy' do
    context 'as admin' do
      it 'can destroy his own activities' do
        activity = Fabricate(:activity, user: @admin)

        expect { 
          delete api_activity_path(activity), {
            user_token: @admin.authentication_token,
            user_email: @admin.email,
          }, request_headers
        }.to change(Activity, :count).by(-1)

        expect(response.status).to eq 204
      end

      it 'can destroy others activities' do
        activity = Fabricate(:activity, user: @user)

        expect { 
          delete api_activity_path(activity), {
            user_token: @admin.authentication_token,
            user_email: @admin.email,
          }, request_headers
        }.to change(Activity, :count).by(-1)

        expect(response.status).to eq 204
      end
    end

    context 'as user' do
      it 'can destroy his own activities' do
        activity = Fabricate(:activity, user: @user)

        expect { 
          delete api_activity_path(activity), {
            user_token: @user.authentication_token,
            user_email: @user.email,
          }, request_headers
        }.to change(Activity, :count).by(-1)

        expect(response.status).to eq 204
      end

      it 'cannot destroy others activities' do
        activity = Fabricate(:activity, user: Fabricate(:user))

        expect { 
          delete api_activity_path(activity), {
            user_token: @user.authentication_token,
            user_email: @user.email,
          }, request_headers
        }.not_to change(Activity, :count)

        expect(response.status).to eq 403
      end
    end

    context 'as guest' do
      it 'prevented from deleting a activity' do
        activity = Fabricate(:activity, user: @user)

        expect { 
          delete api_activity_path(activity), {
            user_token: @guest.authentication_token,
            user_email: @guest.email,
          }, request_headers
        }.not_to change(Activity, :count)

        expect(response.status).to eq 403
      end
    end
  end
end
