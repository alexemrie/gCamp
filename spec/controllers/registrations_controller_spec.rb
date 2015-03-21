require 'rails_helper'

describe RegistrationsController do
  describe 'GET #new' do
    it "should render a new view" do
      get :new
      expect(response).to render_template(:new)
    end

    it "assigns a new user object" do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe 'POST #create' do
    describe 'on success' do
      it 'creates a new user when valid parameters are passed' do
        expect {
          post :create, user: { first_name: "Crazy", last_name: "John", email: "crazyjohn@example.com", password: "123",
             password_confirmation: "123"}}.to change {User.all.count}.by(1)
        user = User.last
        expect(session[:user_id]).to eq(user.id)
        expect(user.first_name).to eq "Crazy"
        expect(flash[:success]).to eq "You have successfully signed up"
        expect(response).to redirect_to new_project_path
      end
    end

    describe 'on failure' do
      it 'does not create a new user when invalid parameters are passed' do
        expect {
          post :create, user: { first_name: "Crazy", last_name: "John", email: nil, password: "123",
             password_confirmation: "123"}}.to_not change {User.all.count}
        expect(response).to render_template(:new)
      end
    end

  end

end
